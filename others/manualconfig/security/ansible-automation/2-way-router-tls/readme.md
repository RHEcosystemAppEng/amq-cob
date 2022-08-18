# Two way TLS/SSL between Red Hat Interconnect Router

## Topology
* In this scenario you are trying to establish a two way TLS/SSL connection between two routers: router <-> router01
* Both routers named as router and router01 present a certificate to each other

## Prerequisites
* Two router instances have been created and available for ssh
* Certificates for two way TLS/SSL for both the router and router01 are generated and available
* The respective router configuration files qdrouterd.conf for both routers is reviewed and configured for any scenario specific use case

## File Inventory for two way TLS/SSL for Red Hat AMQ Interconnect Routers
|Component|File Name|Description|
|---|---|---|
|Router|router.crt| Router certificate |
|Router|router-private-key.key| Router's private key |
|Router|server-ca.crt| Public key of the server certificate authority |
|Router|qdrouterd.conf| Router configuration to support two way TLS/SSL with Red Hat AMQ Interconnect Router|
|Router01|router01.crt| Router01 certificate |
|Router01|router01-private-key.key| Router01's private key |
|Router01|qdrouterd01.conf| Router01 configuration to support two way TLS/SSL with Red Hat AMQ Interconnect Router|

## Ansible Setup of first Router with two way TLS/SSL
* Review all the files as needed in the file inventory for Router components are present
* Review the contents of the files as required especially by the qdrouterd.conf
* Setup router with two way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./router-config.yml
```

## Ansible Setup of second Router01 with two way TLS/SSL
* Review all the files as needed in the file inventory for Router components are present
* Review the contents of the files as required especially by the qdrouterd.conf
* Setup router with two way TLS/SSL with this command
```shell
ansible-playbook -i hosts ./router01-config.yml
```