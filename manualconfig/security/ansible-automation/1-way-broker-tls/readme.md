# One way TLS/SSL Red Hat AMQ Broker & Interconnect Router

## Topology
* In this scenario you are trying to establish a one way TLS/SSL connection between your broker and router: broker -> router
* Broker presents a certificate to router and router validates the same
* According to documentation this is the most common configuration

## Prerequisites
* Broker & Router instances have been created and available for ssh
* Certificates for one way TLS/SSL for Red Hat AMQ Broker are generated and available
* The file broker.xml is reviewed and configured for any scenario specific use case by the broker
* The file qdrouterd.conf is reviewed and configured for any scenario specific use case by the router

## File Inventory for One Way TLS/SSL for Red Hat AMQ Broker
|Component|File Name|Description|
|---|---|---|
|Broker|broker.xml|broker.xml configured for scenario specific use cases|
|Broker|broker-keystore.jks| Broker certificate generated as described in one way TLS/SSL broker procedure |
|Router|server-ca.crt| Public key of the server certificate authority |
|Router|qdrouterd.conf| Router configuration to support one way TLS/SSL with Red Hat AMQ Broker|

## Ansible Setup Broker with one way TLS/SSL
* Review all the files as needed in the file inventory for Broker component are present
* Review the contents of the files as required especially by the broker.xml
* Setup broker with one way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./broker-config.yml
```

## Ansible Setup Router with one way TLS/SSL
* Review all the files as needed in the file inventory for Router component are present
* Review the contents of the files as required especially by the qdrouterd.conf
* Setup router with one way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./router-config.yml
```