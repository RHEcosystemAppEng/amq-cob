# Establish TLS for Red Hat AMQ Brokers and Red Hat AMQ Interconnect Routers

## References
* [Broker one way TLS](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#proc-br-configuring-one-way-TLS_configuring)
* [Broker two way TLS](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#proc_br-configuring-broker-certificate-based-authentication_configuring)
* [Router - Securing outgoing connections](https://access.redhat.com/documentation/en-us/red_hat_amq/7.4/html-single/using_amq_interconnect/index#securing-outgoing-connections-router)
* Java Keytool Commands in Broker Java samples under amq-broker-7.9.0/examples/features/standard/ssl-enabled/ 

## Topology details
* The following simplified topology is used in this example:
    * Broker <-> Router <-> Router01

* It is recommended to make use of a client computer such as Mac to generate all certificates, keys and trust stores in one directory and copy relevant files to appropriate servers, as needed

* To identify host names from command line for a given broker or router and use them in certificate generation process 
```shell
hostname -s
```
* The VM details used are as follows:

|VM Name|Internal IP|Shell Variable Used|
|---|---|---|
|rhkp-jira214-tor2-standalone-broker|10.249.64.11|BROKER_HOST_NAME|
|rhkp-jira214-tor2-standalone-router|10.249.64.12|ROUTER_HOST_NAME|
|rhkp-jira214-tor2-standalone-router-01|10.249.64.5|ROUTER01_HOST_NAME|

## Broker : One way TLS (broker -> router)
* In this scenario only broker presents its certificate to the client and is the most common scenario. 

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

### Red Hat AMQ Broker Configuration
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

* Note: If you get permission errors for the key or certificate files change the ownership to the AMQ Runner user, which is used to run the broker, using chown command.

### Red Hat AMQ Interconnect Configuration
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

## Broker : Two way TLS (broker <-> router)
* Note: 2 way TLS between broker and router works only with SASL ANONYMOUS or PLAIN authentication mechanism
* Ensure the steps above for establishing one way TLS has been completed between router and broker
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
scp router.crt router-private-key.key root@$J214_STANDALONE_ROUTER:/etc/qpid-dispatch
```

### Red Hat AMQ Broker Configuration
* Update broker.xml file acceptor element to support two way TLS

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

### Red Hat AMQ Interconnect Configuration
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
    verifyHostname: no
    # https://qpid.apache.org/releases/qpid-dispatch-1.7.0/user-guide/index.html#adding-ssl-authentication-to-outgoing-connection
    # To specify multiple authentication mechanisms, separate each mechanism with a space.
    saslMechanisms: EXTERNAL ANONYMOUS
}

# If using SASL PLAIN Mechanism uncomment following block and comment or delete SASL ANONYMOUS Block above
#connector {
#    name: broker-connector-1
#    host: 10.249.64.11
#    port: 61616
#    role: route-container
#    sslProfile: broker-tls
#    verifyHostname: no
#    saslMechanisms: EXTERNAL PLAIN
#    saslUsername: admin
#    saslPassword: redhat
#}

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

* If the two way tls between the broker and the router makes use of SASL Plain mechanism, install the SASL Plain Plugin on router
```shell
yum search cyrus-sasl
yum install cyrus-sasl-plain.x86_64
```

* Start the router and ensure no errors are thrown 
```shell
qdrouterd
```

## Securing Routers with TLS (router <-> router01)
* Use this procedure to establish a secure connection between two routers e.g. router and router01

* Generate router certificates for "router01" and be sure to replace alias, ip and dns accordingly
```shell
keytool -keystore router01-keystore.jks -storepass $STORE_PASS -keypass $KEY_PASS -alias router01 -genkey -keyalg "RSA" -keysize 2048 -sigalg sha384WithRSA -dname "CN=$ROUTER01_HOST_NAME OU=Artemis, O=ActiveMQ, L=AMQ, S=AMQ, C=AMQ" -validity $VALIDITY -ext bc=ca:false -ext eku=sA -ext san=dns:localhost,ip:127.0.0.1,dns:router01.rh.cob.j214.com,ip:10.249.64.5;

keytool -keystore router01-keystore.jks -storepass $STORE_PASS -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -alias router01 -certreq -file router01.csr;

keytool -keystore server-ca-keystore.p12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -storepass $STORE_PASS -alias server-ca -gencert -rfc -infile router01.csr -outfile router01.crt -validity $VALIDITY -ext bc=ca:false -ext san=dns:localhost,ip:127.0.0.1,dns:router01.rh.cob.j214.com,ip:10.249.64.5;
```

* Convert router01 keystore jks to p12 format
```shell
keytool -importkeystore -srckeystore router01-keystore.jks -srcstorepass $STORE_PASS -destkeystore router01-keystore.p12 -deststorepass $STORE_PASS -srcstoretype jks -deststoretype pkcs12;
```

* Extract the private key
```shell
openssl pkcs12 -passin pass:$STORE_PASS -in router01-keystore.p12 -out router01-private-key.key -nodes -nocerts;
```

* Copy the certificate, key and CA Certificate to the connecting router
```shell
scp router01.crt router01-private-key.key server-ca.crt root@$J214_STANDALONE_ROUTER_01:/etc/qpid-dispatch
```

* Configure listening router: router

<details>
    <summary>qdrouterd.conf</summary>

```text
router {
    mode: interior
    id: Router.R
}

#SSL Profile for Router 01
sslProfile {
    name: inter-router-tls
    certFile: /etc/qpid-dispatch/router.crt
    privateKeyFile: /etc/qpid-dispatch/router-private-key.key
    caCertFile: /etc/qpid-dispatch/server-ca.crt
    password: redhat
}

#Listener for Router 01
listener {
    host: 0.0.0.0
    port: 5773
    authenticatePeer: yes
    sslProfile: inter-router-tls
    requireSsl: yes
    role: inter-router
    saslMechanisms: EXTERNAL
}

#SSL Profile for Broker
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
    prefix: exclusive
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

* Configure connecting router: router01

<details>
    <summary>qdrouterd.conf</summary>

```text
router {
    mode: interior
    id: router01
}

sslProfile {
    name: inter-router-tls
    certFile: /etc/qpid-dispatch/router01.crt
    privateKeyFile: /etc/qpid-dispatch/router01-private-key.key
    caCertFile: /etc/qpid-dispatch/server-ca.crt
    password: redhat
}

# Connector to router
connector {
    name: router-connector-1
    host: 10.249.64.12
    port: 5773
    role: inter-router
    sslProfile: inter-router-tls
    verifyHostname: false
    saslMechanisms: EXTERNAL
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
    prefix: exclusive
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

## Appendix 1 : Broker & Router two way tls negative tests and results
<details>
    <summary>Case 1 : Invalid Router Certificate ( signed by different CA Cert )</summary>
    
```text
2022-01-28 18:31:38.521803 +0000 SERVER (error) SSL local certificate configuration failed for connection [C1] to 10.249.64.11:61616
2022-01-28 18:31:38.522349 +0000 SERVER (error) [C1] Connection aborted due to internal setup error
2022-01-28 18:31:38.522390 +0000 SERVER (info) [C1] Connection to 10.249.64.11:61616 failed: amqp:connection:framing-error Expected AMQP protocol header: no protocol header found (connection aborted)
```    
</details>
<details>
    <summary>Case 2 : Invalid or Different Router Private Key</summary>

```text
2022-01-28 18:31:38.521803 +0000 SERVER (error) SSL local certificate configuration failed for connection [C1] to 10.249.64.11:61616
2022-01-28 18:31:38.522349 +0000 SERVER (error) [C1] Connection aborted due to internal setup error
2022-01-28 18:31:38.522390 +0000 SERVER (info) [C1] Connection to 10.249.64.11:61616 failed: amqp:connection:framing-error Expected AMQP protocol header: no protocol header found (connection aborted)
```

</details>
<details>
    <summary>Case 3 : Use of invalid CA Cert</summary>

```text
2022-01-28 18:38:40.397443 +0000 SERVER (info) [C1] Connection to 10.249.64.11:61616 failed: amqp:connection:framing-error SSL Failure: error:1416F086:SSL routines:tls_process_server_certificate:certificate verify failed
```
</details>
<details>
    <summary>Case 4 : Enable Certificate Host NameVerification</summary>

```text
2022-01-28 18:38:40.397443 +0000 SERVER (info) [C1] Connection to 10.249.64.11:61616 failed: amqp:connection:framing-error SSL Failure: error:1416F086:SSL routines:tls_process_server_certificate:certificate verify failed
```
</details>
<details>
    <summary>Case 5 : Only specify sslProfile and exclude saslMechanisms altogether</summary>

```text
2022-01-28 19:05:45.738248 +0000 ROUTER_CORE (info) [C1] Connection Opened: dir=out host=10.249.64.11:61616 vhost= encrypted=TLSv1.3 auth=ANONYMOUS user=(null) container_id=localhost props={:product="apache-activemq-artemis", :version="2.18.0.redhat-00010"}
2022-01-28 19:05:45.738323 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/0' on connection broker-connector-1
2022-01-28 19:05:45.738439 +0000 ROUTER_CORE (info) [C1][L9] Link attached: dir=out source={<none> expire:link} target={SampleQueue expire:link}
2022-01-28 19:05:45.738454 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/1' on connection broker-connector-1
2022-01-28 19:05:45.738464 +0000 ROUTER_CORE (info) [C1][L10] Link attached: dir=in source={SampleQueue expire:link} target={<none> expire:link}
```
</details>
<details>
    <summary>Case 6 : Speify sslProfile and provide saslUsername/saslPassword</summary>

```text
2022-01-28 19:08:04.075581 +0000 ROUTER_CORE (info) [C1] Connection Opened: dir=out host=10.249.64.11:61616 vhost= encrypted=TLSv1.3 auth=PLAIN user=admin container_id=localhost props={:product="apache-activemq-artemis", :version="2.18.0.redhat-00010"}
2022-01-28 19:08:04.075712 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/0' on connection broker-connector-1
2022-01-28 19:08:04.075821 +0000 ROUTER_CORE (info) [C1][L9] Link attached: dir=out source={<none> expire:link} target={SampleQueue expire:link}
2022-01-28 19:08:04.075832 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/1' on connection broker-connector-1
2022-01-28 19:08:04.075838 +0000 ROUTER_CORE (info) [C1][L10] Link attached: dir=in source={SampleQueue expire:link} target={<none> expire:link}1
```
</details>

## Appendix 2 : Successful 2 way tls trace level logs between router and broker
<details>
    <summary>Broker Logs</summary>

```text
​​2022-01-27 00:20:22,973 DEBUG [io.netty.handler.ssl.SslHandler] [id: 0xa692fad8, L:/10.249.64.11:61616 - R:/10.249.64.12:34558] HANDSHAKEN: protocol:TLSv1.3 cipher suite:TLS_AES_256_GCM_SHA384
2022-01-27 00:20:23,138 DEBUG [org.apache.activemq.artemis.protocol.amqp.proton.handler.ProtonHandler] onSaslInit: SaslImpl [_outcome=PN_SASL_NONE, state=PN_SASL_STEP, done=false, role=SERVER]
2022-01-27 00:20:23,139 DEBUG [org.apache.activemq.artemis.protocol.amqp.proton.handler.ProtonHandler] saslComplete: SaslImpl [_outcome=PN_SASL_NONE, state=PN_SASL_STEP, done=false, role=SERVER]
2022-01-27 00:20:23,139 FINE  [org.apache.qpid.proton.engine.impl.SaslImpl] SASL negotiation done: SaslImpl [_outcome=PN_SASL_OK, state=PN_SASL_PASS, done=true, role=SERVER]
2022-01-27 00:20:23,146 FINE  [proton.trace] IN: CH[0] : Open{ containerId='Router.R', hostname='10.249.64.11', maxFrameSize=16384, channelMax=32767, idleTimeOut=8000, outgoingLocales=null, incomingLocales=null, offeredCapabilities=[ANONYMOUS-RELAY, qd.streaming-links], desiredCapabilities=[ANONYMOUS-RELAY, qd.streaming-links], properties={product=qpid-dispatch-router, version=Red Hat Interconnect 2.0.0-TP3 (qpid-dispatch 1.17.1), qd.conn-id=4}}

2022-01-27 00:20:23,151 FINE  [proton.trace] IN: CH[0] : Begin{remoteChannel=null, nextOutgoingId=0, incomingWindow=2147483647, outgoingWindow=2147483647, handleMax=4294967295, offeredCapabilities=null, desiredCapabilities=null, properties=null}
2022-01-27 00:20:23,156 FINE  [proton.trace] IN: CH[0] : Attach{name='qdlink.zeTIZfqwYjha3WQ', handle=0, role=SENDER, sndSettleMode=MIXED, rcvSettleMode=FIRST, source=Source{address='null', durable=NONE, expiryPolicy=LINK_DETACH, timeout=0, dynamic=false, dynamicNodeProperties=null, distributionMode=null, filter=null, defaultOutcome=null, outcomes=null, capabilities=null}, target=Target{address='SampleQueue', durable=NONE, expiryPolicy=LINK_DETACH, timeout=0, dynamic=false, dynamicNodeProperties=null, capabilities=null}, unsettled=null, incompleteUnsettled=false, initialDeliveryCount=0, maxMessageSize=0, offeredCapabilities=null, desiredCapabilities=null, properties=null}
2022-01-27 00:20:23,157 FINE  [proton.trace] IN: CH[0] : Attach{name='qdlink.2rHA1rWAvO_P+Sv', handle=1, role=RECEIVER, sndSettleMode=MIXED, rcvSettleMode=FIRST, source=Source{address='SampleQueue', durable=NONE, expiryPolicy=LINK_DETACH, timeout=0, dynamic=false, dynamicNodeProperties=null, distributionMode=null, filter=null, defaultOutcome=null, outcomes=null, capabilities=null}, target=Target{address='null', durable=NONE, expiryPolicy=LINK_DETACH, timeout=0, dynamic=false, dynamicNodeProperties=null, capabilities=null}, unsettled=null, incompleteUnsettled=false, initialDeliveryCount=0, maxMessageSize=0, offeredCapabilities=null, desiredCapabilities=null, properties=null}
```

</details>

<details>
    <summary>Router Logs</summary>
    
```text
2022-01-27 00:20:23.151318 +0000 ROUTER_CORE (info) [C4] Connection Opened: dir=out host=10.249.64.11:61616 vhost= encrypted=TLSv1.3 auth=ANONYMOUS user=(null) container_id=localhost props={:product="apache-activemq-artemis", :version="2.18.0.redhat-00010"}
2022-01-27 00:20:23.151393 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/0' on connection broker-connector-1
2022-01-27 00:20:23.151509 +0000 ROUTER_CORE (info) [C4][L9] Link attached: dir=out source={<none> expire:link} target={SampleQueue expire:link}
2022-01-27 00:20:23.151519 +0000 ROUTER_CORE (info) Auto Link Activated 'autoLink/1' on connection broker-connector-1
2022-01-27 00:20:23.151526 +0000 ROUTER_CORE (info) [C4][L10] Link attached: dir=in source={SampleQueue expire:link} target={<none> expire:link}
```
</details>