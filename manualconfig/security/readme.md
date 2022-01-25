# Establish SSL/TLS for Red Hat AMQ Brokers and Red Hat AMQ Interconnect Routers

## References
* [Broker one way TLS](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#proc-br-configuring-one-way-TLS_configuring)
* [Broker two way TLS](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#proc_br-configuring-broker-certificate-based-authentication_configuring)
* Java Keytool Commands in Broker Java samples under amq-broker-7.9.0/examples/features/standard/ssl-enabled/ 

## Prerequisites
* Initial installation Red Hat AMQ Broker and Interconnect Router on two different VMs is completed

## Broker : One way TLS/SSL

* Identify host names from command line for a given broker or router
```shell
hostname -s
```

* Set key environment variables for your respective broker or router with the names identified above
```shell
# Set ENV VARS
KEY_PASS=redhat STORE_PASS=redhat CA_VALIDITY=3650 VALIDITY=1460 BROKER_HOST_NAME=rhkp-jira214-tor2-standalone-broker ROUTER_HOST_NAME=rhkp-jira214-tor2-standalone-router
ROUTER01_HOST_NAME=rhkp-jira214-tor2-standalone-router-01
```
* Generate CA Certificates for use in your topology. 
```shell
keytool -storetype pkcs12 -keystore server-ca-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -alias server-ca -genkey -keyalg "RSA" -keysize 2048 -sigalg sha384WithRSA -dname "CN=ActiveMQ Artemis Server Certification Authority, OU=Artemis, O=ActiveMQ" -validity $CA_VALIDITY -ext bc:c=ca:true,pathlen:0  -startdate -1m;

keytool -storetype pkcs12 -keystore server-ca-keystore.p12 -storepass $STORE_PASS -alias server-ca -exportcert -rfc > server-ca.crt;
```
* Generate Broker Certificate, replace ip and dns parameters according to the environment that you are using
```shell
keytool -keystore broker-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -alias broker -genkey -keyalg "RSA" -keysize 2048 -sigalg sha384WithRSA -dname "CN=$BROKER_HOST_NAME, OU=Artemis, O=ActiveMQ, L=AMQ, S=AMQ, C=AMQ" -validity $VALIDITY -ext bc=ca:false -ext eku=sA -ext san=dns:localhost,ip:127.0.0.1,dns:rh.cob.j214.com,ip:10.249.64.11;

keytool -keystore broker-keystore.jks -storepass $STORE_PASS -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -alias broker -certreq -file broker.csr;

keytool -keystore server-ca-keystore.p12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -storepass $STORE_PASS -alias server-ca -gencert -rfc -infile broker.csr -outfile broker.crt -validity $VALIDITY -ext bc=ca:false -ext san=dns:localhost,ip:127.0.0.1,dns:rh.cob.j214.com,ip:10.249.64.11;
```
*  Import CA and Broker Certs into Broker Key Store
```shell
keytool -keystore broker-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias server-ca -file server-ca.crt -noprompt;
keytool -keystore broker-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias broker -file broker.crt;
```
* Create Trust Store with CA Cert for use by Broker
```shell
keytool -keystore server-ca-truststore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias server-ca -file server-ca.crt -noprompt;
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

* Red Hat AMQ Broker Configuration
<details>
    <summary>broker.xml</summary>

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
</details>

* Start the broker and ensure no errors are thrown 
```shell
"/var/opt/amq-broker/broker-01/bin/artemis" run
```

* Note: If you get permission errors for the key or certificate files change the ownership to the AMQ Runner user, which is used to run the broker using chown command.

* Red Hat AMQ Interconnect Configuration
<details>
    <summary>qdrouterd.conf</summary>

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
</details>

* Start the router and ensure no errors are thrown 
```shell
qdrouterd
```

## Broker : Two way TLS/SSL
* Ensure the steps above to establishing one way TLS has been completed
* Implementation of two way TLS makes use of cert usage by Broker and Router along with SASL PLAIN mechanism

* Generate router Certificates. Please replace ip and dns parameters accordingly
```shell
keytool -keystore router-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -alias router -genkey -keyalg "RSA" -keysize 2048 -sigalg sha384WithRSA -dname "CN=$ROUTER_HOST_NAME OU=Artemis, O=ActiveMQ, L=AMQ, S=AMQ, C=AMQ" -validity $VALIDITY -ext bc=ca:false -ext eku=sA -ext san=dns:localhost,ip:127.0.0.1,dns:router.rh.cob.j214.com,ip:10.249.64.12;

keytool -keystore router-keystore.jks -storepass $STORE_PASS -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -alias router -certreq -file router.csr;

keytool -keystore server-ca-keystore.p12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -storepass $STORE_PASS -alias server-ca -gencert -rfc -infile router.csr -outfile router.crt -validity $VALIDITY -ext bc=ca:false -ext san=dns:localhost,ip:127.0.0.1,dns:router.rh.cob.j214.com,ip:10.249.64.12;
```
* Convert router keystore jks to p12 format
```shell
keytool -importkeystore -srckeystore router-keystore.jks -srcstorepass $STORE_PASS -destkeystore router-keystore.p12 -deststorepass $STORE_PASS -srcstoretype jks -deststoretype pkcs12;
```
* Extract the private key
```shell
openssl pkcs12 -passin pass:$STORE_PASS -in router-keystore.p12 -out router-private-key.key -nodes -nocerts
```

* Copy the server-ca-truststore.p12 to the Broker
```shell
scp server-ca-truststore.p12 root@$J214_STANDALONE_BROKER:/var/opt/amq-broker/broker-01/etc
```

* Copy the router-private-key.key & router.crt to the Router
```shell
scp router-private-key.key router.crt root@$J214_STANDALONE_ROUTER:/etc/qpid-dispatch
```

* Update broker.xml file acceptor element to support two way SSL/TLS
```xml
    <acceptor name="netty-ssl-acceptor">tcp://10.249.64.11:61616?sslEnabled=true;keyStorePath=../etc/server-keystore.jks;keyStorePassword=redhat;enabledProtocols=TLSv1,TLSv1.1,TLSv1.2;needClientAuth=true;trustStorePath=../etc/server-ca-truststore.p12;trustStorePassword=redhat</acceptor>
```

<details>
    <summary>broker.xml</summary>

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
         <acceptor name="netty-ssl-acceptor">tcp://10.249.64.11:61616?sslEnabled=true;keyStorePath=../etc/server-keystore.jks;keyStorePassword=redhat;enabledProtocols=TLSv1,TLSv1.1,TLSv1.2;needClientAuth=true;trustStorePath=../etc/server-ca-truststore.p12;trustStorePassword=redhat</acceptor>
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
</details>

* Replace the default configuration of login.config with following

<details>
    <summary>login.config</summary>

```text
activemq {
    org.apache.activemq.artemis.spi.core.security.jaas.TextFileCertificateLoginModule sufficient
        debug=true
        reload=true
        org.apache.activemq.jaas.textfiledn.user="artemis-users.properties"
        org.apache.activemq.jaas.textfiledn.role="artemis-roles.properties";

   org.apache.activemq.artemis.spi.core.security.jaas.GuestLoginModule sufficient
       debug=false
       org.apache.activemq.jaas.guest.user="admin"
       org.apache.activemq.jaas.guest.role="amq";
};
```
</details>

* Add this line to the end of artemis-users.properties file for user router. This router user is identified by a TLS Certificate which has "CN=Interconn Router,O=ActiveMQ,C=AMQ"
```text
router=CN=Interconn Router,O=ActiveMQ,C=AMQ
```

* The artemis-roles.properties file should look as follows, where we are saying the user router belongs to role amq.
```text
amq = admin,router
```

* Start the broker and ensure no errors are thrown 
```shell
"/var/opt/amq-broker/broker-01/bin/artemis" run
```

* Red Hat AMQ Interconnect Configuration
<details>
    <summary>qdrouterd.conf</summary>

```text
router {
    mode: standalone
    id: Router.R
}

sslProfile {
    name: broker-tls
    caCertFile: /etc/qpid-dispatch/server-ca.crt
    certFile: /etc/qpid-dispatch/router.crt
    privateKeyFile: /etc/qpid-dispatch/router-private-key.key
    password:  pass:redhat
}

connector {
    name: broker-connector-1
    host: 10.249.64.11
    port: 61616
    role: route-container
    sslProfile: broker-tls
    saslMechanisms: PLAIN
    saslUsername: admin
    saslPassword: redhat
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
</details>

* Start the router and ensure no errors are thrown 
```shell
qdrouterd
```

* 
```shell
```
* 
```shell
```
* 
```shell
```