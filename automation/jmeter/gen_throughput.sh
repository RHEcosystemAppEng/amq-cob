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
        printf ' -->> ERROR: %s\n\n' "$message"
    fi

    cat <<- USAGE_INFO
      Usage: $0 [options] -i <jmeter_JTL_file>
          jmeter_JTL_file is the input file that contains JMeter log sample result
                and is generated using the "-l" option when running jmeter
          and options are:
            -a|A: consumer sample size to aggregate
            -b|B: producer sample size to aggregate
            -c|C: consumer label
            -p|P: producer label
            -f|F: output format. Valid choice is either "json" or "csv"
                  Default is json
            -z|Z: deduce sample size to aggregate from JTL file
                  -a/-b options will be ignored if provided

        e.g: $0 -c SUB -i /tmp/jmeter.jtl
             This will read JMeter sample logs from the /tmp/jmeter.jtl file
             and use "SUB" text to look for consumer lines.
             By default, it will take 200 as the samples to aggregate and
                         "JMS Publisher" text to look for the producer lines
                         and output will be in json format

        e.g: $0 -c CONSUME -p PUB -i /tmp/jmeter.jtl -a 2500 -b 1000 -f csv
             This will:
              - read JMeter sample logs from the /tmp/jmeter.jtl file
              - and use "CONSUME" text to look for consumer lines
              - and "PUB" text to look for the producer lines.
              - 2500 will be used as the samples to aggregate for the consumer
              - 1000 will be used as the samples to aggregate for the producer
              - output will be in the "csv" format
USAGE_INFO

    exit 1
}


TIME_DIFF_SECONDS=
#------------------------------------------------------------------------------------------------------------------
# Computes time diff using the two timestamp values provided and sets it in the "TIME_DIFF_SECONDS" global variable
#
# @param lastTimestamp
# @param firstTimestamp
#------------------------------------------------------------------------------------------------------------------
function compute_time_diff() {
    TIME_DIFF_SECONDS=
    local lastTimestamp=$1
    local firstTimestamp=$2

    local timeDiffMillis="$((lastTimestamp - firstTimestamp))"

    # https://stackoverflow.com/questions/2395284/round-a-divided-number-in-bash
    local timeDiffSeconds="$(( (timeDiffMillis + 500) / 1000))"   # round up by adding "demon/2" to the numerator

    if [ $timeDiffSeconds -eq 0 ]; then
      timeDiffSeconds=1
    fi

    TIME_DIFF_SECONDS=$timeDiffSeconds
}


#------------------------------------------------------------------------------------------------------------------
# Computes throughput for producer/consumer and combined based on given parameters
#------------------------------------------------------------------------------------------------------------------
function calculate_throughput() {
    local jmeterLogFile=$1
    local producerLabel=$2
    local consumerLabel=$3
    local outputFormat=$4
    local readSampleSizeFromJTL=$5
    local producerSamplesToAggregate=$6
    local consumerSamplesToAggregate=$7

    if [ "$readSampleSizeFromJTL" == "true" ]; then
      # Pick up 1st word (field) from 5th column of 1st line matching producer label that has a 200 responseCode
      producerSamplesToAggregate=`egrep "$producerLabel" "$jmeterLogFile" | egrep -m 1 ',200,' | awk -F',' '{print $5}' | awk -F' ' '{print $1}'`

      # Pick up 2nd last word (field) from 5th column of 1st line matching consumer label that has a 200 or 500 responseCode
      # Consumers don't always get 200 response as there are cases where we ONLY got the 500 response for a client
      consumerSamplesToAggregate=`egrep "$consumerLabel" "$jmeterLogFile" | egrep -m 1 ',200,|,500,' | awk -F',' '{print $5}' | awk -F' ' '{print $(NF-1)}'`
    fi

    # timestamp is given in the 1st field for matching lines that has a 200 or 500 responseCode
    # Consumers don't always get 200 response as there are cases where we ONLY got the 500 response for a client
    local producerFirstTimestamp=`cat "$jmeterLogFile" | awk -F',' 'FNR == 2 {print $1}'`   # read timestamp from 2nd line
    local producerLastTimestamp=`egrep "$producerLabel" "$jmeterLogFile" | egrep ',200,|,500,' | tail -1 | awk -F',' '{print $1}'`  # from last match
    local consumerFirstTimestamp=`egrep "$consumerLabel" "$jmeterLogFile" | egrep -m 1 ',200,|,500,' | awk -F',' '{print $1}'`  # from 1st match
    local consumerLastTimestamp=`egrep "$consumerLabel" "$jmeterLogFile" | egrep ',200,|,500,' | tail -1 | awk -F',' '{print $1}'`  # from last match

    compute_time_diff $producerLastTimestamp $producerFirstTimestamp
    local producerTimeDiffSeconds=$TIME_DIFF_SECONDS

    compute_time_diff $consumerLastTimestamp $consumerFirstTimestamp
    local consumerTimeDiffSeconds=$TIME_DIFF_SECONDS

    compute_time_diff $consumerLastTimestamp $producerFirstTimestamp
    local timeDiffSeconds=$TIME_DIFF_SECONDS

    # Full sample aggregate lines (where number of messages sent/received == sample aggregate size)
    local producerCount=`egrep "$producerLabel" "$jmeterLogFile" | egrep -c ',200,'`
    local consumerCount=`egrep "$consumerLabel" "$jmeterLogFile" | egrep -c ',200,'`

    # Count "Consumer" lines that are NOT with 200 or 404 responseCode. JMeter will mark the consumer lines
    # with responseCode 404 where 0 messages are received
    # and with responseCode 500 where less than expected messages are received
    local consumerCountPartial=`egrep "$consumerLabel" "$jmeterLogFile" | egrep -vc ',404,|,200,'`

    # Pick up "Consumer" lines that are NOT with 200 or 404 responseCode, picking up 5th column that contains
    # "N message(s) received successfully of <sample_aggregate_size> expected" text. And, finally extract the
    # 1st column from this field that is the actual number of messages received and sum it up for each line
    local consumerSampleCountPartial=`egrep "$consumerLabel" "$jmeterLogFile" | egrep -v ',404,|,200,' | awk -F',' '{print $5}' | awk -F' ' '{print $1}' | paste -sd+ - | bc`

    local producerSampleCount="$((producerCount * producerSamplesToAggregate))"
    # Also add consumer partial sample count to get total number of  consumer messages
    local consumerSampleCount="$(( (consumerCount * consumerSamplesToAggregate) + consumerSampleCountPartial))"

    local producerThroughput="$((producerSampleCount / producerTimeDiffSeconds))"
    local consumerThroughput="$((consumerSampleCount / consumerTimeDiffSeconds))"
    local combinedThroughput="$(( (producerSampleCount + consumerSampleCount) / timeDiffSeconds))"

    case $outputFormat in
      json)
        printf '\n
        {
          "time_info": {
            "producer_timestamp_millis": { "first": "%s", "last": "%s" },
            "consumer_timestamp_millis": { "first": "%s", "last": "%s" },
            "diff_in_seconds": { "producer": "%s", "consumer": "%s", "combined": "%s" }
          },
          "count": {
             "producer": "%s",
             "consumer": { full: "%s", partial: "%s" }
           },
          "sample_size": {
            "to_aggregate": { "producer": "%s", "consumer": "%s" },
            "total_aggregated": { "producer": "%s", "consumer": "%s" }
          },
          "throughput_sec": {"producer": "%s", "consumer": "%s", "combined": "%s"}
        }\n' \
          "$producerFirstTimestamp" "$producerLastTimestamp" \
          "$consumerFirstTimestamp" "$consumerLastTimestamp" \
          "$producerTimeDiffSeconds" "$consumerTimeDiffSeconds" "$timeDiffSeconds" \
          "$producerCount" "$consumerCount" "$consumerCountPartial" \
          "$producerSamplesToAggregate" "$consumerSamplesToAggregate" "$producerSampleCount" "$consumerSampleCount" \
          "$producerThroughput" "$consumerThroughput" "$combinedThroughput"
        ;;
      csv)
        printf 'producer_first_timestamp, producer_last_timestamp, consumer_first_timestamp, consumer_last_timestamp, producer_diff_seconds, consumer_diff_seconds, combined_diff_seconds, producer_count, consumer_count, consumer_partial_count, producer_samples_to_aggregate, consumer_samples_to_aggregate, producer_samples_aggregated, consumer_samples_aggregated, producer_throughput, consumer_throughput, combined_throughput\n'
        printf '%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n' \
          "$producerFirstTimestamp" "$producerLastTimestamp" \
          "$consumerFirstTimestamp" "$consumerLastTimestamp" \
          "$producerTimeDiffSeconds" "$consumerTimeDiffSeconds" "$timeDiffSeconds" \
          "$producerCount" "$consumerCount" "$consumerCountPartial" \
          "$producerSamplesToAggregate" "$consumerSamplesToAggregate" "$producerSampleCount" "$consumerSampleCount" \
          "$producerThroughput" "$consumerThroughput" "$combinedThroughput"
        ;;
    esac

  unset TIME_DIFF_SECONDS
}


#------------------------------------------------------------------------------------------------------------------
# Function that parses the command line args and executes in following manner if all the arguments are present:
#  - reads the specified input log file and computes the throughput for:
#     - producer
#     - consumer
#     - combined
#
# Command line options are provided in detail in the "USAGE" function
#------------------------------------------------------------------------------------------------------------------
function process_cmd_args() {
    if [ $# -eq 0 ]; then
        USAGE
    fi

    local consumerLabel="JMS Subscriber"
    local producerLabel="JMS Publisher"
    local producerSamplesToAggregate=200  # default value
    local consumerSamplesToAggregate=200  # default value
    local outputFormat="json"
    local jmeterLogFile
    local incorrectUsageMessage
    local readSampleSizeFromJTL=false

    while getopts a:A:b:B:c:C:f:F:p:P:i:I:zZ arg
    do
        case $arg in
          c|C)
            consumerLabel="$OPTARG"
            ;;
          p|P)
            producerLabel="$OPTARG"
            ;;
          a|A)
            consumerSamplesToAggregate="$OPTARG"
            ;;
          b|B)
            producerSamplesToAggregate="$OPTARG"
            ;;
          z|Z)
            readSampleSizeFromJTL=true
            ;;
          i|I)
            jmeterLogFile="${OPTARG}"
            if [ ! -f "$jmeterLogFile" ]; then
              incorrectUsageMessage="Input file [$jmeterLogFile] does not exist. Please provide a valid jmeter log file as the input..."
            fi
            ;;
          f|F)
            outputFormat="${OPTARG}"
            case $outputFormat in
              csv|json)
                # valid format. Do nothing
              ;;
              *)
                incorrectUsageMessage="$outputFormat is an invalid option for output format. Valid options are either csv or json"
              ;;
            esac
            ;;
          *)
            incorrectUsageMessage="** INVALID option: [$arg]. Valid options are: s|S, p|P and i|I";;
        esac
    done

    if [ ! -z "$incorrectUsageMessage" ]; then
      USAGE "$incorrectUsageMessage"
    fi

     calculate_throughput "$jmeterLogFile" "$producerLabel" "$consumerLabel" "$outputFormat" "$readSampleSizeFromJTL" "$producerSamplesToAggregate" "$consumerSamplesToAggregate"
}

process_cmd_args "$@"
