# Red Hat AMQ Two Instance Cluster on single Fedora Server VM

## Prerequisites
* Established single AMQ Instance

## Add second AMQ instance
* Setup environment variables on Mac & ssh into Fedora Server for AMQ Broker
```shell
export AMQBROKER=192.168.56.107
ssh rhkp@$AMQBROKER
```

* Create a directory for the broker instance and grant ownership to the amq-broker user.
```shell
sudo mkdir /var/opt/amq-broker2;
sudo chown -R amq-broker:amq-broker /var/opt/amq-broker2;
```

* Use the artemis create command to create the broker.
```shell
su - amq-broker;
cd /var/opt/amq-broker2;
<install-dir>/bin/artemis create mybroker2
```

* You can use following sample values for prompts, here I have used password: redhat 
```text
Creating ActiveMQ Artemis instance at: /var/opt/amq-broker2/mybroker2

--user: is a mandatory property!
Please provide the default username:
admin

--password: is mandatory with this configuration:
Please provide the default password:


--allow-anonymous | --require-login: is a mandatory property!
Allow anonymous access?, valid values are Y,N,True,False
Y

Auto tuning journal ...
done! Your system can make 50 writes per millisecond, your journal-buffer-timeout will be 20000
```
### Change bootstrap.xml configuration
* Edit the /var/opt/amq-broker2/mybroker2/etc/bootstrap.xml
```shell
cd /var/opt/amq-broker2/mybroker2/etc/
vi bootstrap.xml
```

* Update the AMQ port by changing the following line from
```xml
<web bind="http://localhost:8161" path="web">
```
* to
```xml
<web bind="http://localhost:8171" path="web">
```

### Change broker.xml configuration
* Edit the broker.xml for the second broker instance
```shell
vi broker.xml
```

* Add the connectors section just above the acceptors section 
```xml
    <!-- Connectors -->
    <connectors>
        <connector name="netty-connector">tcp://localhost:61627</connector>
        <!-- connector to the server0 -->
        <connector name="server0-connector">tcp://localhost:61626</connector>
    </connectors>

    <!-- Acceptors -->
    <acceptors>    
```

* Add the updated acceptors section with changed ports ( so as not to collide ports with our first instance ) 
```xml
    <!-- Acceptors -->
    <acceptors>
        <acceptor name="netty-acceptor">tcp://localhost:61627</acceptor>
        <!-- useEpoll means: it will use Netty epoll if you are on a system (Linux) that supports it -->
        <!-- amqpCredits: The number of credits sent to AMQP producers -->
        <!-- amqpLowCredits: The server will send the # credits specified at amqpCredits at this low mark -->
        <!-- amqpDuplicateDetection: If you are not using duplicate detection, set this to false
                                    as duplicate detection requires applicationProperties to be parsed on the server. -->
        <!-- amqpMinLargeMessageSize: Determines how many bytes are considered large, so we start using files to hold their data.
                                    default: 102400, -1 would mean to disable large mesasge control -->

        <!-- Note: If an acceptor needs to be compatible with HornetQ and/or Artemis 1.x clients add
                "anycastPrefix=jms.queue.;multicastPrefix=jms.topic." to the acceptor url.
                See https://issues.apache.org/jira/browse/ARTEMIS-1644 for more information. -->


        <!-- Acceptor for every supported protocol -->
        <acceptor name="artemis">tcp://0.0.0.0:61716?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;amqpMinLargeMessageSize=102400;protocols=CORE,AMQP,STOMP,HORNETQ,MQTT,OPENWIRE;useEpoll=true;amqpCredits=1000;amqpLowCredits=300;amqpDuplicateDetection=true;supportAdvisory=false;suppressInternalManagementObjects=false</acceptor>

        <!-- AMQP Acceptor.  Listens on default AMQP port for AMQP traffic.-->
        <acceptor name="amqp">tcp://0.0.0.0:5772?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;protocols=AMQP;useEpoll=true;amqpCredits=1000;amqpLowCredits=300;amqpMinLargeMessageSize=102400;amqpDuplicateDetection=true</acceptor>

        <!-- STOMP Acceptor. -->
        <acceptor name="stomp">tcp://0.0.0.0:61713?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;protocols=STOMP;useEpoll=true</acceptor>

        <!-- HornetQ Compatibility Acceptor.  Enables HornetQ Core and STOMP for legacy HornetQ clients. -->
        <acceptor name="hornetq">tcp://0.0.0.0:5545?anycastPrefix=jms.queue.;multicastPrefix=jms.topic.;protocols=HORNETQ,STOMP;useEpoll=true</acceptor>

        <!-- MQTT Acceptor -->
        <acceptor name="mqtt">tcp://0.0.0.0:1983?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;protocols=MQTT;useEpoll=true</acceptor>

    </acceptors>
```

* Add the clustering section below acceptors section
```xml
    <!-- Clustering configuration -->
    <cluster-connections>
        <cluster-connection name="my-cluster">
        <connector-ref>netty-connector</connector-ref>
        <retry-interval>500</retry-interval>
        <use-duplicate-detection>true</use-duplicate-detection>
        <message-load-balancing>STRICT</message-load-balancing>
        <max-hops>1</max-hops>
        <static-connectors>
            <connector-ref>server0-connector</connector-ref>
        </static-connectors>
        </cluster-connection>
    </cluster-connections>
```

* Add a queue inside the addresses section
```xml
    <address name="MyQAddr">
        <anycast>
        <queue name="MyQAddr"/>
        </anycast>
    </address>
```
* Sample broker.xml file is provided for comparison

## Update first AMQ instance configuration

### Change the broker.xml file configuration

* Edit the broker.xml
```shell
su - amq-broker;
cd /var/opt/amq-broker/mybroker/etc/;
vi broker.xml
```

* Add the connectors section just above the acceptors
```xml
      <!-- Connectors -->
      <connectors>
         <connector name="netty-connector">tcp://localhost:61626</connector>
         <!-- connector to the server1 -->
         <connector name="server1-connector">tcp://localhost:61627</connector>
      </connectors>

      <!-- Acceptors -->
```

* Add the acceptor line in acceptors section
```xml
    <!-- Acceptors -->
    <acceptors>
        <acceptor name="netty-acceptor">tcp://localhost:61626</acceptor>
        ...   
```

* Add the cluster-connections section
```xml
    </acceptors>

    <cluster-connections>
        <cluster-connection name="my-cluster">
        <connector-ref>netty-connector</connector-ref>
        <retry-interval>500</retry-interval>
        <use-duplicate-detection>true</use-duplicate-detection>
        <message-load-balancing>STRICT</message-load-balancing>
        <max-hops>1</max-hops>
        <static-connectors>
            <connector-ref>server1-connector</connector-ref>
        </static-connectors>
        </cluster-connection>
    </cluster-connections>
```

* Add a queue inside the addresses section
```xml
    <address name="MyQAddr">
        <anycast>
        <queue name="MyQAddr"/>
        </anycast>
    </address>
```

## Start the AMQ Brokers
* In a new terminal window start the first instance 
```shell
/var/opt/amq-broker/mybroker/bin/artemis run
```

* In a new terminal window start the second instance 
```shell
/var/opt/amq-broker2/mybroker2/bin/artemis run
```

* Ensure that both brokers start and no errors are thrown 
