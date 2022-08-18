# Java Client & Broker One Way TLS

## Summary of the Key Files of the Java Project
|File Name|Description|
|---|---|
|AMQClient| Client class establishing connection with broker, sending and receiving a text message|
|jndi.properties| Configuration for one way TLS connection to broker|
|server-ca-truststore.p12| Client verifies Broker certificate using the CA certificate authority public key|

## Running the Java Client
* The technique used here is to build a fat jar with all dependencies and then execute the Java Client main class
```shell
mvn package
java -cp target/j214-client-1.0-SNAPSHOT-jar-with-dependencies.jar org.rh.cob.j214.AMQClient
```