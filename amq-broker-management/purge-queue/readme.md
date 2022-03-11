# Red Hat AMQ Broker Purge Queue using JMS Java Sample

## Summary of the Key Files of the Java Project
|File Name|Description|
|---|---|
|PurgeQueue.java| Sample class to purge queue programmatically using JMS messages |
|jndi.properties| Configuration for broker properties |

## Running the Java Client
* The technique used here is to build a fat jar with all dependencies and then execute the Java Client main class
```shell
mvn package
java -cp target/j435-client-1.0-SNAPSHOT-jar-with-dependencies.jar org.rh.cob.purge.PurgeQueue
```