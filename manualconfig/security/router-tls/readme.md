# Establish TLS among Red Hat Interconnect Routers

## References
* [Securing Network Connections](https://access.redhat.com/documentation/en-us/red_hat_amq/7.4/html-single/using_amq_interconnect/index#securing-network-connections-router)
* [Red Hat Support Case](https://access.redhat.com/support/cases/#/case/03124328) 

## Prerequisites
* Initial installation Red Hat AMQ Interconnect Routers is completed

## Implementation of TLS among routers in Aggregator Pattern

### Generate Router's Certificates and Keys
* Set useful environment variables for servers. Server names can be found from each router server with command "hostname -s"
```shell
export AGGREGATE=rhkp-jira97-tor2-aggregate-router;
export PRODUCER=rhkp-jira97-tor2-producer-router;
export CONSUMER=rhkp-jira97-tor2-consumer-router;
```
* Generate CA Certificate first with following commands
```shell
# CA CERT 
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore ca.pkcs12 -storepass redhat -alias ca -keypass redhat -genkey -dname "O=Red Hat Inc.,CN=redhat.com" -validity 99999 -ext bc:c=ca:true,pathlen:0  -startdate -1m
openssl pkcs12 -nokeys -passin pass:redhat -in ca.pkcs12 -passout pass:redhat -out ca-certificate.pem
```

* Generate Aggregator Certificate
```shell
# AGGREGATE
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore aggregate.pkcs12 -storepass redhat -alias aggregate-certificate -keypass redhat -genkey  -dname "O=Server,CN=$AGGREGATE" -validity 99999;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore aggregate.pkcs12 -storepass redhat -alias aggregate-certificate -keypass redhat -certreq -file aggregate-request.pem;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore ca.pkcs12 -storepass redhat -alias ca -keypass redhat -gencert -rfc -validity 99999 -infile aggregate-request.pem -outfile aggregate-certificate.pem;
openssl pkcs12 -nocerts -passin pass:redhat -in aggregate.pkcs12 -passout pass:redhat -out aggregate-private-key.pem;
```

* Generate Producer Certificate
```shell
# PRODUCER
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore producer.pkcs12 -storepass redhat -alias producer-certificate -keypass redhat -genkey  -dname "C=US,ST=NC,L=Raleigh,OU=Dev,O=Client,CN=$PRODUCER" -validity 99999;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore producer.pkcs12 -storepass redhat -alias producer-certificate -keypass redhat -certreq -file producer-request.pem;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore ca.pkcs12 -storepass redhat -alias ca -keypass redhat -gencert -rfc -validity 99999 -infile producer-request.pem -outfile producer-certificate.pem;
openssl pkcs12 -nocerts -passin pass:redhat -in producer.pkcs12 -passout pass:redhat -out producer-private-key.pem;
```

* Generate Consumer Certificate
```shell
# CONSUMER
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore consumer.pkcs12 -storepass redhat -alias consumer-certificate -keypass redhat -genkey  -dname "C=US,ST=NC,L=Raleigh,OU=Dev,O=Client,CN=$CONSUMER" -validity 99999;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore consumer.pkcs12 -storepass redhat -alias consumer-certificate -keypass redhat -certreq -file consumer-request.pem;
keytool -storetype pkcs12 -keyalg RSA -keysize 2048 -sigalg sha384WithRSA -keystore ca.pkcs12 -storepass redhat -alias ca -keypass redhat -gencert -rfc -validity 99999 -infile consumer-request.pem -outfile consumer-certificate.pem;
openssl pkcs12 -nocerts -passin pass:redhat -in consumer.pkcs12 -passout pass:redhat -out consumer-private-key.pem;
```

### Configuration of Aggregator: qdrouterd.conf 

* Copy and paste the following configuration in qdrouterd.conf file
```text
router {
    mode: interior
    id: Router.A
}

sslProfile {
    name: inter-router-tls
    certFile: /etc/qpid-dispatch/aggregate-certificate.pem
    privateKeyFile: /etc/qpid-dispatch/aggregate-private-key.pem
    caCertFile: /etc/qpid-dispatch/ca-certificate.pem
    password: redhat
}

# Listener for Inter-Router connections
listener {
    host: 0.0.0.0
    port: 5773
    authenticatePeer: yes
    sslProfile: inter-router-tls
    requireSsl: yes
    role: inter-router
    saslMechanisms: EXTERNAL
}

# Listener for AMQ Console
listener {
    name: amq-console
    role: normal
    host: 0.0.0.0
    port: 5673
    http: yes
}

connector {
    name: broker-connector-2
    host: 10.249.64.5
    port: 61617
    role: route-container
    saslMechanisms: ANONOYMOUS
}

connector {
    name: broker-connector-1
    host: 10.249.64.4
    port: 61617
    role: route-container
    saslMechanisms: ANONYMOUS
}

# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
    distribution: closest
}

# Create Autolink to send messages to the broker 2
autoLink {
    address: SampleQueue
    connection: broker-connector-2
    direction: in
}

autoLink {
    address: SampleQueue
    connection: broker-connector-2
    direction: out
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

* Start the router 
```shell
qdrouterd
```

### Configuration of Producer: qdrouterd.conf 

* Copy and paste the following configuration in qdrouterd.conf file
```text
router {
    mode: interior
    id: Router.P
}

# Listener for Clients
listener {
    host: 0.0.0.0
    port: 5772
    authenticatePeer: no
    saslMechanisms: ANONYMOUS
}

sslProfile {
    name: inter-router-tls
    certFile: /etc/qpid-dispatch/producer-certificate.pem
    privateKeyFile: /etc/qpid-dispatch/producer-private-key.pem
    caCertFile: /etc/qpid-dispatch/ca-certificate.pem
    password: redhat
}

# Connector to Aggregate
connector {
    name: aggregate-connector-1
    host: 10.249.64.6
    port: 5773
    role: inter-router
    sslProfile: inter-router-tls
    verifyHostname: false
    saslMechanisms: EXTERNAL
}

# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    distribution: closest
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

* Start the router 
```shell
qdrouterd
```

### Configuration of Consumer: qdrouterd.conf 

* Copy and paste the following configuration in qdrouterd.conf file
```text
router {
    mode: interior
    id: Router.C
}

# Listener for Clients
listener {
        host: 0.0.0.0
        port: 5772
        authenticatePeer: no
        saslMechanisms: ANONYMOUS
}

sslProfile {
    name: inter-router-tls
    certFile: /etc/qpid-dispatch/consumer-certificate.pem
    privateKeyFile: /etc/qpid-dispatch/consumer-private-key.pem
    caCertFile: /etc/qpid-dispatch/ca-certificate.pem
    password: redhat
}

# Connector to Aggregate
connector {
    name: aggregagte-connector-1
    host: 10.249.64.6
    port: 5773
    role: inter-router
    sslProfile: inter-router-tls
    verifyHostname: false
    saslMechanisms: EXTERNAL

}

# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
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

* Start the router 
```shell
qdrouterd
```