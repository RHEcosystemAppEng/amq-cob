#!/bin/bash


#============================================================================
# Script to read the JMeter log and generate throughput numbers for
# producer/consumer and combined
#============================================================================


#------------------------------------------------------------------------------------------------------------------
# Displays usage and exits
#
# @param message to display before usage
#------------------------------------------------------------------------------------------------------------------
function USAGE() {
    local message="$1"

    if [ ! -z "$message" ]; then
        echo $message
    fi

    cat <<- USAGE_INFO
      Usage: $0 -s [consumer label] -p [publisher label] -a [samples to aggregate] -i <jmeter_log_file>
      INVALID option: [$arg]. Valid options are: s|S, p|P and i|I
        where
          jmeter_log_file is the input file in jmeter log format
          -c|C is to specify consumer label
          -p|P is to specify publisher label
          -a|A is to specify samples to aggregate
          -i|I is to specify the JMeter log file

        e.g: $0 -s SUB -i /tmp/jmeter.log
             This will read JMeter logs from the /tmp/jmeter.log file and use "SUB" text to look for consumer lines.
             By default, it will take 200 as the samples to aggregate and
                         "JMS Publisher" text to look for the publisher lines

        e.g: $0 -c CONSUME -p PUB -i /tmp/jmeter.log -a 2500
             This will read JMeter logs from the /tmp/jmeter.log file and use "CONSUME" text to look for consumer
             lines and "PUB" text to look for the publisher lines.
             It will take 2500 as the samples to aggregate

USAGE_INFO

    exit 1
}

#------------------------------------------------------------------------------------------------------------------
# Computes throughput for publisher/consumer and combined based on given parameters
#------------------------------------------------------------------------------------------------------------------
function calculate_throughput() {
    local jmeterLogFile=$1
    local publisherLabel=$2
    local consumerLabel=$3
    local samplesToAggregate=$4

    printf "\n -->> Using following data: logFile=%s, publisher=%s, consumer=%s, samplesToAggregate=%s\n" \
      "$jmeterLogFile" "$publisherLabel" "$consumerLabel" "$samplesToAggregate"

    local firstTimestamp=`cat "$jmeterLogFile" | awk -F',' 'FNR == 2 {print $1}'`
    local lastTimestamp=`tail -1 "$jmeterLogFile" | awk -F',' '{print $1}'`
    local timeDiffMillis="$((lastTimestamp - firstTimestamp))"
    local timeDiffSeconds="$((timeDiffMillis / 1000))"

    local publisherCount=`egrep -c "$publisherLabel" "$jmeterLogFile"`
    local consumerCount=`egrep -c "$consumerLabel" "$jmeterLogFile"`

    local publisherSampleCount="$((publisherCount * samplesToAggregate))"
    local consumerSampleCount="$((consumerCount * samplesToAggregate))"

    local publisherThroughput="$((publisherSampleCount / timeDiffSeconds))"
    local consumerThroughput="$((consumerSampleCount / timeDiffSeconds))"
    local combinedThroughput="$(( (publisherSampleCount + consumerSampleCount) / timeDiffSeconds))"

#    printf "\n --> first=%s, last=%s, diff=(ms=%s, seconds=%s)" \
#      "$firstTimestamp" "$lastTimestamp" "$timeDiffMillis" "$timeDiffSeconds"
#
#    printf "\n --> numberOf=[occurrence=(publisher=%s, consumer=%s), samples=(publisher=%s, consumer=%s)]" \
#      "$publisherCount" "$consumerCount" "$publisherSampleCount" "$consumerSampleCount"
#
#    printf '\n --> throughput/sec=(publisherTh=%s, consumer=%s, combined=%s)\n' \
#      "$publisherThroughput" "$consumerThroughput" "$combinedThroughput"

    printf '\n {
       "timestamp": { "first": "%s", "last": "%s" },
       "diff": { "ms": "%s", "seconds": "%s" },
       "numberOf": {
         "occurrence": { "publisher": "%s", "consumer": "%s" },
         "samples": { "publisher": "%s", "consumer": "%s"
         }
       },
       "throughput/sec": {"publisher": "%s", "consumer": "%s", "combined": "%s"}
     }\n' \
      "$firstTimestamp" "$lastTimestamp" "$timeDiffMillis" "$timeDiffSeconds" \
      "$publisherCount" "$consumerCount" "$publisherSampleCount" "$consumerSampleCount" \
      "$publisherThroughput" "$consumerThroughput" "$combinedThroughput"

}


#------------------------------------------------------------------------------------------------------------------
# Function that parses the command line args and executes in following manner if all the arguments are present:
#  - reads the specified input log file and computes the throughput for:
#     - producer
#     - consumer
#     - combined
#
# Command line options are expected with following flag:
#  -s|S: consumer
#  -d|D: directory for the region - relative to the script location
#------------------------------------------------------------------------------------------------------------------
function process_cmd_args() {
    if [ $# -eq 0 ]; then
        USAGE
    fi

    local consumerLabel="JMS Subscriber"
    local publisherLabel="JMS Publisher"
    local samplesToAggregate=200  # default value
    local jmeterLogFile
    local incorrectUsageMessage

    while getopts c:C:p:P:i:I:a:A: arg
    do
        case $arg in
          c|C)
            consumerLabel="$OPTARG"
            ;;
          p|P)
            publisherLabel="$OPTARG"
            ;;
          a|A)
            samplesToAggregate="$OPTARG"
            ;;
          i|I)
            jmeterLogFile="${OPTARG}"
            if [ ! -f "$jmeterLogFile" ]; then
              USAGE "Invalid file ($jmeterLogFile) - file does not exist..."
              incorrectUsageMessage="Input file [$jmeterLogFile] does not exist. Please provide a valid jmeter log file as the input..."
            fi
            ;;
          *)
            incorrectUsageMessage="** INVALID option: [$arg]. Valid options are: s|S, p|P and i|I";;
        esac
    done

    calculate_throughput "$jmeterLogFile" "$publisherLabel" "$consumerLabel" "$samplesToAggregate"
}

process_cmd_args "$@"
