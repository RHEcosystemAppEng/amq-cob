# Red Hat AMQ Broker Purge Queue using JMS Java Sample with SSL

## Summary of the Key Files of the Java Project
|File Name|Description|
|---|---|
|PurgeQueue.java| Sample class to purge queue programmatically using JMS messages |
|jndi.properties| Configuration for broker properties |
|java-client-keystore.p12| Java Client Private Key & Certificate|
|server-ca-truststore.p12| Truststore with CA Certificate |

## SSL Configuration in jndi.properties
* SSL Broker connection configuration needs to have the following additional configuration
```text
<Broker URL>?sslEnabled=true&trustStorePath=server-ca-truststore.p12&trustStorePassword=redhat&keyStorePath=java-client-keystore.p12&keyStorePassword=redhat
```

## Running the Java Client
* The technique used here is to build a fat jar with all dependencies and then execute the Java Client main class
```shell
mvn package
java -cp target/j435-client-1.0-SNAPSHOT-jar-with-dependencies.jar org.rh.cob.purge.PurgeQueue
```