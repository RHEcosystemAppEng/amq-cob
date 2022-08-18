# Two way TLS/SSL Red Hat AMQ Broker & Interconnect Router

## Topology
* In this scenario you are trying to establish a two way TLS/SSL connection between your broker and router: broker <-> router
* Broker & router both present a certificate to each other

## Prerequisites
* Broker & Router instances have been created and available for ssh
* Certificates for two way TLS/SSL for Red Hat AMQ Broker are generated and available
* The file broker.xml is reviewed and configured for any scenario specific use case by the broker
* The file qdrouterd.conf is reviewed and configured for any scenario specific use case by the router

## File Inventory for two way TLS/SSL for Red Hat AMQ Broker
|Component|File Name|Description|
|---|---|---|
|Broker|broker.xml|broker.xml configured for scenario specific use cases|
|Broker|artemis-roles.properties|Roles configuration to support 2 way configuration|
|Broker|artemis-users.properties|User configuration to support 2 way configuration|
|Broker|login.config|Login/auth configuration to support 2 way configuration|
|Broker|server-ca-truststore.p12|Trust store with Router's certificate|
|Router|router.crt| Router certificate |
|Router|router-private-key.key| Router's private key |
|Router|server-ca.crt| Public key of the server certificate authority |
|Router|qdrouterd.conf| Router configuration to support two way TLS/SSL with Red Hat AMQ Broker|

## Ansible Setup Broker with two way TLS/SSL
* Review all the files as needed in the file inventory for Broker component are present
* Review the contents of the files as required especially by the broker.xml
* Setup broker with two way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./broker-config.yml
```

## Ansible Setup Router with two way TLS/SSL
* Review all the files as needed in the file inventory for Router component are present
* Review the contents of the files as required especially by the qdrouterd.conf
* Setup router with two way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./router-config.yml
```