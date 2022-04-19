#!/bin/sh

function runBenchmark(){
local HOST_ADDRESS=$1
printf "Running jmeter test and generating JTL file."

jmeter -n -t "${currentDir}/AMQ_Jmeter_Test_Plan_local.jmx" \
  -JproducerDuration=10 \
  -JconsumerDuration=20 \
  -l "${outputDir}/jmeter_results_${HOST_ADDRESS}.jtl"

printf  "Calculating throughout from JTL file."
./gen_throughput.sh "-i" "${outputDir}/jmeter_results_${HOST_ADDRESS}.jtl"

printf "Generating CSV report"
local PUBLISHER_THROUGHPUT=$(cat jtl_throughput_results.json| jq ".throughputSec.publisher")
local CONSUMER_THROUGHPUT=$(cat jtl_throughput_results.json| jq ".throughputSec.consumer")
local COMBINED_THROUGHPUT=$(cat jtl_throughput_results.json| jq ".throughputSec.combined")

printf "\n127.0.0.1,${PUBLISHER_THROUGHPUT}, ${CONSUMER_THROUGHPUT}, ${COMBINED_THROUGHPUT} " >> "${outputDir}/amq_benchmark_report.csv"
}

function generateJndiPropertiesFile(){
  rm -f /tmp/jndi.properties
  echo "java.naming.factory.initial=org.apache.qpid.jms.jndi.JmsInitialContextFactory\n" >> /tmp/jndi.properties
  echo "connectionfactory.QueueConnectionFactory = amqp://$1:5672\n" >> /tmp/jndi.properties
  echo "queue.exampleQueue = exampleQueue" >> /tmp/jndi.properties
}

BROKER_IP_ADDRESS=$1
ROUTER_IP_ADDRESS=$2
JVM_ARGS="-Xms4048m -Xmx6096m"

currentDir=$(pwd)

outputDir=$(pwd)/amq_benchmark
printf ${outputDir}
rm -rf "${outputDir}"
mkdir -p "${outputDir}"
printf "broker/router IP, Publisher Throughput, Consumer Throughput, Combined Throughput" > "${outputDir}/amq_benchmark_report.csv"

generateJndiPropertiesFile "${BROKER_IP_ADDRESS}"
runBenchmark "${BROKER_IP_ADDRESS}"

#generateJndiPropertiesFile "${ROUTER_IP_ADDRESS}"
#runBenchmark "${ROUTER_IP_ADDRESS}"