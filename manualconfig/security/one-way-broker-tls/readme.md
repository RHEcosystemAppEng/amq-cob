# Establish One Way Broker TLS

## References
* [Broker one way TLS](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#proc-br-configuring-one-way-TLS_configuring)
* Java Keytool Commands in Broker Java samples under amq-broker-7.9.0/examples/features/standard/ssl-enabled/ 

## Prerequisites
* Initial installation Red Hat AMQ Broker and Interconnect Router on two different VMs is completed

## Generate Broker CA Certs and Server Certs
* Note: this process can be completed on your Mac.

* Set key environment variables

```shell
KEY_PASS=redhat STORE_PASS=redhat CA_VALIDITY=365000 VALIDITY=36500
```
* Generate Server CA (server-ca-keystore.p12) & Keys
```shell
keytool -storetype pkcs12 -keystore server-ca-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -alias server-ca -genkey -keyalg "RSA" -keysize 2048 -dname "CN=ActiveMQ Artemis Server Certification Authority, OU=Artemis, O=ActiveMQ" -validity $CA_VALIDITY -ext bc:c=ca:true
```
* Export Server CA Certificate (server-ca.crt)
```shell
keytool -storetype pkcs12 -keystore server-ca-keystore.p12 -storepass $STORE_PASS -alias server-ca -exportcert -rfc > server-ca.crt
```
* Create Server CA Trust Store(server-ca-truststore.p12) and import Server CA Certificate
```shell
keytool -keystore server-ca-truststore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias server-ca -file server-ca.crt -noprompt
```
* Generate Broker(  server-keystore.jks) Key Pair
```shell
keytool -keystore server-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -alias server -genkey -keyalg "RSA" -keysize 2048 -dname "CN=ActiveMQ Artemis Server, OU=Artemis, O=ActiveMQ, L=AMQ, S=AMQ, C=AMQ" -validity $VALIDITY -ext bc=ca:false -ext eku=sA -ext san=dns:localhost,ip:127.0.0.1,dns:rh.cob.j214.com,ip:10.249.64.11
```
* Create CSR(server.csr)
```shell
keytool -keystore server-keystore.jks -storepass $STORE_PASS -alias server -certreq -file server.csr
```
* Generate Server Certificate(server.crt)
```shell
keytool -keystore server-ca-keystore.p12 -storepass $STORE_PASS -alias server-ca -gencert -rfc -infile server.csr -outfile server.crt -validity $VALIDITY -ext bc=ca:false -ext san=dns:localhost,ip:127.0.0.1,dns:rh.cob.j214.com,ip:10.249.64.11
```
* Import Server CA Certificate in Server Keystore (server-keystore.jks)
```shell
keytool -keystore server-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias server-ca -file server-ca.crt -noprompt
```
* Import Server Certificate in Server Keystore (server-keystore.jks)
```shell
keytool -keystore server-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias server -file server.crt
```
* Make Sure the Server Certificate verifies with CA Certificate
```shell
openssl verify -verbose -CAfile server-ca.crt  server.crt
```
* Copy the server-keystore.jks to the Broker
```shell
scp server-keystore.jks root@$J214_STANDALONE_BROKER:/var/opt/amq-broker/broker-01/etc
```

* Copy the server-ca.crt to the Router
```shell
scp server-ca.crt root@$J214_STANDALONE_ROUTER:/etc/qpid-dispatch
```

## Configuration of AMQ Router: broker.xml 

* Edit the broker.xml file
```shell
vi broker.xml
```
* Copy and paste the following xml configuration in broker.xml file
```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">
   <core xmlns="urn:activemq:core">
      <bindings-directory>./data/messaging/bindings</bindings-directory>
      <journal-directory>./data/messaging/journal</journal-directory>
      <large-messages-directory>./data/messaging/largemessages</large-messages-directory>
      <paging-directory>./data/messaging/paging</paging-directory>

      <!-- Acceptors -->
      <acceptors>
         <acceptor name="netty-ssl-acceptor">tcp://10.249.64.11:61616?sslEnabled=true;keyStorePath=../etc/server-keystore.jks;keyStorePassword=redhat;enabledProtocols=TLSv1,TLSv1.1,TLSv1.2;</acceptor>
      </acceptors>

      <security-settings>
         <security-setting match="#">
            <permission type="createNonDurableQueue" roles="amq"/>
            <permission type="deleteNonDurableQueue" roles="amq"/>
            <permission type="createDurableQueue" roles="amq"/>
            <permission type="deleteDurableQueue" roles="amq"/>
            <permission type="createAddress" roles="amq"/>
            <permission type="deleteAddress" roles="amq"/>
            <permission type="consume" roles="amq"/>
            <permission type="browse" roles="amq"/>
            <permission type="send" roles="amq"/>
            <!-- we need this otherwise ./artemis data imp wouldn't work -->
            <permission type="manage" roles="amq"/>
         </security-setting>
      </security-settings>

      <addresses>
         <address name="SampleQueue">
            <anycast>
               <queue name="SampleQueue"/>
            </anycast>
         </address>
      </addresses>
   </core>
</configuration>
```

* Start the broker and ensure no errors are thrown 
```shell
"/var/opt/amq-broker/broker-01/bin/artemis" run
```

## Configuration of AMQ Interconnect Router: qdroutered.conf
* Edit the qdroutered.conf file using vi
```shell
vi qdrouerd.conf
```
* Copy and paste this config
```text
router {
    mode: standalone
    id: Router.R
}

sslProfile {
    name: broker-tls
    caCertFile: /etc/qpid-dispatch/server-ca.crt
    password:  pass:redhat
}

connector {
    name: broker-connector-1
    host: 10.249.64.11
    port: 61616
    role: route-container
    sslProfile: broker-tls
    saslMechanisms: ANONYMOUS
    verifyHostname: no
}

# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
}

# Create Autolink to send messages to the broker 1
autoLink {
    address: SampleQueue
    connection: broker-connector-1
    direction: out
}

autoLink {
    address: SampleQueue
    connection: broker-connector-1
    direction: in
}

listener {
    host: 0.0.0.0
    port: amqp
    authenticatePeer: no
    saslMechanisms: ANONYMOUS
}

listener {
    host: 0.0.0.0
    port: 8672
    authenticatePeer: no
    http: yes
}

address {
    prefix: closest
    distribution: closest
}

address {
    prefix: multicast
    distribution: multicast
}

address {
    prefix: unicast
    distribution: closest
}

address {
    prefix: broadcast
    distribution: multicast
}
```

* Start the router and ensure no errors are thrown 
```shell
qdrouterd
```