# Security TLS/SSL Certificate Automation for Red Hat AMQ Brokers & Red Hat AMQ Interconnect Routers

## Objectives
* Generate CA certificates for development and testing purposes
* Generate certificates for routers and brokers for use by one way and two way TLS/SSL scenarios

## Prerequisites
* Ansible, OpenSSL and OpenJDK 11 are installed on certificate generation host

## Generate CA Certificate
* Execute the CA Certificate Generation Script
```shell
ansible-playbook ./ca.yml
```
## Generate Broker Certificate
* Execute the Broker Certificate Generation Script
```shell
ansible-playbook ./broker.yml
```
## Generate Router Certificate
* Execute the Router Certificate Generation Script
```shell
ansible-playbook ./router.yml
```
## Generate Router01 Certificate
* Execute the Router01 Certificate Generation Script
```shell
ansible-playbook ./router01.yml
```
## Under the hood

### CA Certificate Generation Shell Script: gen-ca-cert.sh
* The file 'gen-ca-cert.sh' is used under Ansible run to generate the CA Certificates
* Edit this script directly to make use of scenario specific values including validity and certificate authority names

### Server Certificate Generation Shell Script: gen-server-cert.sh
* This is a reusable certificate generation script for servers such as brokers and routers
* This script provides means to provide command line arguments for variables.
* The arguments can be provided with 'argument=value' format, where '=' sign is used as delimiter and there should be no spaces around it.

### Example Certificate Generation Shell Script: gen-example-certs.sh
* If you prefer not to use the Ansible CLI you may use samples provided in this shell script to generate certificates on command line

```shell
# Generate CA Certs e.g. for Dev or Test Scenarios
./gen-ca-cert.sh;

# Generate Broker Certificate
./gen-server-cert.sh \
SERVER_HOST_NAME=rhkp-jira214-tor2-standalone-broker \
SERVER_IP=10.249.64.11 \
SERVER_DNS_NAME=www.rhkp.j214.broker.redhat.com \
CERT_FILE_PREFIX=broker \
IMPORT_CERT_CHAIN_IN_JKS=yes \
GEN_PRIVATE_KEY=no;

# Generate Router Certificate
./gen-server-cert.sh \
SERVER_HOST_NAME=rhkp-jira214-tor2-standalone-router \
SERVER_IP=10.249.64.12 \
SERVER_DNS_NAME=www.rhkp.j214.router.redhat.com \
CERT_FILE_PREFIX=router;

# Generate Router01 Certificate
./gen-server-cert.sh \
SERVER_HOST_NAME=rhkp-jira214-tor2-standalone-router-01 \
SERVER_IP=10.249.64.5 \
SERVER_DNS_NAME=www.rhkp.j214.router01.redhat.com \
CERT_FILE_PREFIX=router01;
```

### Customize Ansible yml files for specific situations
* You will have one specific yml for each server having a specific host name and IP address e.g. one for broker, one for router and one for router01
* The Ansible yml files make use of the aforementioned shell scripts for CA and Server certificate generation
* For each server you can copy an existing file and change scenario specific configuration by specifying the values under 'vars' section. Please be sure to use/reference same variables in the command line for certificate generation.