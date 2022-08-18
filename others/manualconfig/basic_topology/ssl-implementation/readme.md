# Red Hat AMQ HA & DR Basic Topology SSL Implementation

## Prerequisites
* Non-ssl version of the basic topology is up and running
* SSL Certificates are generated for servers and clients including certificate authority

## SSL Certificate Generation
* Prepare or update the basic-topology-cert-gen.yml with appropriate server names, internal/external IPs
* Generate the certificates with the playbook created above
```shell
ansible-playbook basic-topology-cert-gen.yml
```
* Copy generated certificates and CA Certs to target servers using scp command on both TOR and WDC sites
* E.g. brokers require broker.crt, broker-keystore.p12 & server-ca-truststore.p12 files
* Routers require router.crt, router-private-key.key and server-ca.crt files

## Site 1 - TOR Setup

### Broker Setup
#### Primary Broker Setup
* broker.xml - copy the contents of tor-files/tor-broker-primary.xml 
* artemis-roles.properties - copy the contents of common-files/artemis-roles.properties 
* login.config - copy the contents of common-files/login.config 
* artemis-users.properties - append the contents of common-files/artemis-users.properties 

#### Backup Broker Setup
* broker.xml - copy the contents of tor-files/tor-broker-
backup.xml 
* artemis-roles.properties - copy the contents of common-files/artemis-roles.properties 
* login.config - copy the contents of common-files/login.config 
* artemis-users.properties - append the contents of common-files/artemis-users.properties 

#### Start the brokers
```shell
ssh root@<Master broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run

ssh root@<Slave broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run
```

### Interconnect Setup
* qdrouterd.conf - copy the contents of tor-files/tor-router-qdrouterd.conf

* Use the following command to start the Interconnect router
```shell
qdrouterd
```

## Site 2 - WDC Setup

### Broker Setup
#### Primary Broker Setup
* broker.xml - copy the contents of wdc-files/wdc-broker-primary.xml 
* artemis-roles.properties - copy the contents of common-files/artemis-roles.properties 
* login.config - copy the contents of common-files/login.config 
* artemis-users.properties - append the contents of common-files/artemis-users.properties 

#### Backup Broker Setup
* broker.xml - copy the contents of wdc-files/wdc-broker-
backup.xml 
* artemis-roles.properties - copy the contents of common-files/artemis-roles.properties 
* login.config - copy the contents of common-files/login.config 
* artemis-users.properties - append the contents of common-files/artemis-users.properties 

#### Start the brokers
```shell
ssh root@<Master broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run

ssh root@<Slave broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run
```

### Interconnect Setup
* qdrouterd.conf - copy the contents of wdc-files/wdc-router-qdrouterd.conf

* Use the following command to start the Interconnect router
```shell
qdrouterd
```

## Java Test Sender & Receiver with SSL
* Make use of [Java Client 2 way SSL with Router](https://github.com/RHEcosystemAppEng/amq-cob/tree/rhkp-jira301/manualconfig/security/java-clients-ssl/router-client-2-way-ssl) Sender and Receivers to test the setup from the client host such as Mac
* Remember to update the router IP addresses in jndi.properties files of Sender and Receiver clients


## Appendix 1 - IBM Cloud Core Component Inventory
### IBM Cloud VPCs
| VPC Name | Region | IP Subnets |
|---|---|---|
|rhkp-cob-amq-vpc|TOR|10.249.0.0/24, 10.249.64.0/24, 10.249.128.0/24|
|rhkp-wdc-cob-amq-vpc|WDC|10.241.0.0/24, 10.241.64.0/24, 10.241.128.0/24|

### IBM Cloud Transit Gateways
|Name|Region|Comment|
|---|---|---|
|rhkp-tor-cob-global-gateway|TOR|Connect two VPCs in TOR and WDC|

### TOR - IBM Cloud VM Details
|VM Name| Region| Availability Zone|Internal IP|Comment|
|---|---|---|---|---|
|rhkp-tor1-broker-01|TOR|1|10.249.0.4|Red Hat AMQ Broker 01|
|rhkp-tor2-broker-02|TOR|2|10.249.64.7|Red Hat AMQ Broker 02|
|rhkp-tor2-nfs-server-01|TOR|2|10.249.64.8|NFS Server for shared storage|
|rhkp-tor3-router-01|TOR|3|10.249.128.4|Red Hat Interconnect Router|

### WDC - IBM Cloud VM Details
|VM Name| Region| Availability Zone|Internal IP|Comment|
|---|---|---|---|---|
|rhkp-wdc1-broker-01|WDC|1|10.241.0.6|Red Hat AMQ Broker 01|
|rhkp-wdc2-broker-02|WDC|2|10.241.64.6|Red Hat AMQ Broker 02|
|rhkp-wdc2-nfs-server-01|WDC|2|10.241.64.4|NFS Server for shared storage|
|rhkp-wdc3-router-01|WDC|3|10.241.128.4|Red Hat Interconnect Router|
