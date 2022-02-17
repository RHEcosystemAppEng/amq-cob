# Java Client & Router Two Way TLS

## Summary of the Key Files of the Java Project

### Sender Client
|File Name|Description|
|---|---|
|Sender.java| Client class sending sample messages to a SampleQueue|
|jndi.properties| Configuration for two way TLS connection to router|
|java-client-keystore.p12| Client keystore with client private key and client certificate|
|server-ca-truststore.p12| Client verifies Router certificate using the CA certificate authority public key|

### Receiver Client
|File Name|Description|
|---|---|
|Receiver.java| Client class sending sample messages to a SampleQueue|
|jndi.properties| Configuration for two way TLS connection to router|
|java-client-keystore.p12| Client keystore with client private key and client certificate|
|server-ca-truststore.p12| Client verifies Router certificate using the CA certificate authority public key|

## Running the Sender Java Client
* The technique used here is to build a fat jar with all dependencies and then execute the Java Client main class
```shell
cd <Sender Client Directory>
mvn package
java -cp target/amq-interconnect-sender-1.0-SNAPSHOT-jar-with-dependencies.jar org.apache.qpid.jms.example.pubsub.Sender
```

## Running the Receiver Java Client
* The technique used here is to build a fat jar with all dependencies and then execute the Java Client main class
```shell
cd <Receiver Client Directory>
mvn package
java -cp target/amq-interconnect-receiver-1.0-SNAPSHOT-jar-with-dependencies.jar org.apache.qpid.jms.example.pubsub.Receiver
```