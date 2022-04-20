#!/bin/sh

function runBenchmark(){
local HOST_ADDRESS=$1

printf "Running jmeter test and generating JTL file."
JVM_ARGS="-Xms4g -Xmx6g"
jmeter -n -t "${currentDir}/AMQ_Jmeter_Test_Plan_local.jmx" \
  -JproducerDuration=10 \
  -JconsumerDuration=20 \
  -JproducerSamples=1000 \
  -JconsumerSamples=2000 \
  -l "${outputDir}/jmeter_results_${HOST_ADDRESS}.jtl"

printf  "Calculating throughput from JTL file."
./gen_throughput.sh "-i" "${outputDir}/jmeter_results_${HOST_ADDRESS}.jtl" -a 1000 -b 2000 -f csv -c "JMS Subscriber" -p "JMS Publisher" > "${outputDir}/jmeter_csv_results_${HOST_ADDRESS}.csv"

printf  "Benchmark is done..!!"
}

function generateJndiPropertiesFile(){
  rm -f /tmp/jndi.properties
  echo "java.naming.factory.initial=org.apache.qpid.jms.jndi.JmsInitialContextFactory\n" >> /tmp/jndi.properties
  echo "connectionfactory.QueueConnectionFactory = amqp://$1:5672\n" >> /tmp/jndi.properties
  echo "queue.exampleQueue = exampleQueue" >> /tmp/jndi.properties
}

BROKER_IP_ADDRESS=$1
ROUTER_IP_ADDRESS=$2

currentDir=$(pwd)

outputDir=$(pwd)/amq_benchmark
printf ${outputDir}
rm -rf "${outputDir}"
mkdir -p "${outputDir}"

generateJndiPropertiesFile "${BROKER_IP_ADDRESS}"
runBenchmark "${BROKER_IP_ADDRESS}"

generateJndiPropertiesFile "${ROUTER_IP_ADDRESS}"
runBenchmark "${ROUTER_IP_ADDRESS}"