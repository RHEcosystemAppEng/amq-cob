# Eample certificate generation for the simple topology used Broker <-> Router <-> Router01

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