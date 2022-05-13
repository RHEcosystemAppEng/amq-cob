#!/bin/sh


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
      Usage: $0 [options] -h <broker or router dns name or ip address>
          and options are:
            -d|D: Producer test duration, default is 15 seconds
            -e|E: Consumer test duration, default is 30 seconds
            -s|S: Producer sample size, default is 500
            -t|T: Consumer sample size, default is 500
            -u|U: Producer Threads, default is 1
            -v|V: Consumer threads, default is 5
            -j|J: JMS timeout. Default is 3000

        e.g: $0 -h 163.75.95.11
             This will perform a jmeter test against the router/broker address 163.75.95.11 with all the default options.

USAGE_INFO

    exit 1
}



function runBenchmark(){
  local host=$1
  local producerDuration=$2
  local consumerDuration=$3
  local producerSamples=$4
  local consumerSamples=$5
  local producerThreads=$6
  local consumerThreads=$7
  local jmsTimeout=$8

printf "runBenchmark Properties ----> producerDuration=[${producerDuration}] consumerDuration=[${consumerDuration}] producerSamples=[${producerSamples}] consumerSamples=[${consumerSamples}] producerThreads=[${producerThreads}] consumerThreads=[${consumerThreads}] jmsTimeout=[${jmsTimeout}] host=[${host}] incorrectUsageMessage=[${incorrectUsageMessage}]"

printf "Running jmeter test and generating JTL file."

rm -rf out.log jmeter.log results_automated.jtl redhat_subscription.log && \
   jmeter -n -t "AMQ_Jmeter_Test_Plan_local.jmx" \
  -JproducerDuration="${producerDuration}" \
  -JconsumerDuration="${consumerDuration}" \
  -JproducerSamples="${producerSamples}" \
  -JconsumerSamples="${consumerSamples}" \
  -JjmsTimeout="${jmsTimeout}" \
  -JproducerThreads="${producerThreads}" \
  -JconsumerThreads="${consumerThreads}" \
  -l "${outputDir}/results_automated.jtl" \
  -j out.log

printf "Jmeter test is completed."

printf  "Calculating throughput from JTL file."
./gen_throughput.sh "-i" "${outputDir}/results_automated.jtl" -z > "${outputDir}/output.json"

cat "${outputDir}/output.json"
printf  "Benchmark is done..!!"
}

function generateJndiPropertiesFile(){
  rm -f /tmp/jndi.properties
  echo "java.naming.factory.initial=org.apache.qpid.jms.jndi.JmsInitialContextFactory" >> /tmp/jndi.properties
  echo "connectionfactory.QueueConnectionFactory = amqp://$1:5672" >> /tmp/jndi.properties
  echo "queue.exampleQueue = exampleQueue" >> /tmp/jndi.properties
}

function process_cmd_args() {
    if [ $# -eq 0 ]; then
        USAGE
    fi

    local producerDuration=15
    local consumerDuration=30
    local producerSamples=500
    local consumerSamples=500
    local producerThreads=1
    local consumerThreads=5
    local jmsTimeout=3000
    local host
    local incorrectUsageMessage

    while getopts d:D:e:E:s:S:t:T:u:U:v:V:j:J:h:H arg
    do
      case $arg in
          d|D)
            producerDuration="$OPTARG"
            ;;
          e|E)
            consumerDuration="$OPTARG"
            ;;
          s|S)
            producerSamples="$OPTARG"
            ;;
          t|T)
            consumerSamples="$OPTARG"
            ;;
          u|U)
            producerThreads="$OPTARG"
            ;;
          v|V)
            consumerThreads="$OPTARG"
            ;;
          j|J)
            jmsTimeout="$OPTARG"
            ;;
          h|H)
            host="$OPTARG"
            ;;
          *)
            incorrectUsageMessage="** INVALID option: [$arg]. Check usage for all the options.";;
        esac
    done

    if [ ! -z "$incorrectUsageMessage" ]; then
      USAGE "$incorrectUsageMessage"
    fi

    [ -z "$host" ] && USAGE "host of the broker/router is mandatory"

     local currentDir=$(pwd)

     local outputDir=$(pwd)/amq_benchmark
     printf ${outputDir}
     rm -rf "${outputDir}"
     mkdir -p "${outputDir}"

     printf "process_cmd_args Properties ----> producerDuration=[${producerDuration}] consumerDuration=[${consumerDuration}] producerSamples=[${producerSamples}] consumerSamples=[${consumerSamples}] producerThreads=[${producerThreads}] consumerThreads=[${consumerThreads}] jmsTimeout=[${jmsTimeout}] host=[${host}] incorrectUsageMessage=[${incorrectUsageMessage}]"

     generateJndiPropertiesFile "${host}"
     runBenchmark "${host}" "${producerDuration}" "${consumerDuration}" "${producerSamples}" "${consumerSamples}" "${producerThreads}" "${consumerThreads}" "${jmsTimeout}"
  }

process_cmd_args "$@"