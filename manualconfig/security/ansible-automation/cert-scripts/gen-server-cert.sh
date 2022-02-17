#!/bin/sh

# Reusable script to generate server certificates

# Default variables and default values for use by the Commands
# Pass argument=value from the command line to override the variable value used by the script
# Note: = is used as delimiter and there should be no spaces around the = sign
# e.g. ./gen-server-cert.sh KEYPASS=new-value

KEY_PASS=redhat 
STORE_PASS=redhat 
CA_VALIDITY=3650 
VALIDITY=1460
KEY_SIZE=2048 
ORG_UNIT=Artemis
ORG=ActiveMQ
LOCALITY=AMQ
STATE=AMQ
COUNTRY=AMQ
SERVER_CA_ALIAS=server-ca
SERVER_CA_CERT_FILE_NAME=server-ca.crt
SERVER_HOST_NAME=to_be_changed
SERVER_INTERNAL_IP=10.10.10.10
SERVER_EXTERNAL_IP=111.111.111.111 # For scenarios e.g. Java clients which use external IP to establish secure connection
SERVER_DNS_NAME=www.to.be.changed.com
CERT_FILE_PREFIX=to_be_changed
IMPORT_CERT_CHAIN_IN_JKS=no
GEN_PRIVATE_KEY=yes

if [ "$#" -lt 5 ]; then
    echo "Warning: You may be using default names and it may result in errors in your certificates"
fi

# Source: https://unix.stackexchange.com/questions/129391/passing-named-arguments-to-shell-scripts
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"
   #echo $KEY $VALUE
   export "$KEY"="$VALUE"
done

echo "Generate $CERT_FILE_PREFIX Keystore: $CERT_FILE_PREFIX-keystore.p12"
keytool -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -alias $CERT_FILE_PREFIX -genkey -keyalg "RSA" -keysize $KEY_SIZE -sigalg sha384WithRSA -dname "CN=$SERVER_HOST_NAME, OU=$ORG_UNIT, O=$ORG, L=$LOCALITY, S=$STATE, C=$COUNTRY" -validity $VALIDITY -ext bc=ca:false -ext eku=sA -ext san=dns:localhost,ip:127.0.0.1,dns:$SERVER_DNS_NAME,ip:$SERVER_INTERNAL_IP,ip:$SERVER_EXTERNAL_IP;

echo "Generate $CERT_FILE_PREFIX CSR: $CERT_FILE_PREFIX.csr"
keytool -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -keyalg RSA -keysize $KEY_SIZE -sigalg sha384WithRSA -alias $CERT_FILE_PREFIX -certreq -file $CERT_FILE_PREFIX.csr;

echo "Generate $CERT_FILE_PREFIX Certificate: $CERT_FILE_PREFIX.crt"
keytool -keystore server-ca-keystore.p12 -keyalg RSA -keysize $KEY_SIZE -sigalg sha384WithRSA -storepass $STORE_PASS -alias $SERVER_CA_ALIAS -gencert -rfc -infile $CERT_FILE_PREFIX.csr -outfile $CERT_FILE_PREFIX.crt -validity $VALIDITY -ext bc=ca:false -ext san=dns:localhost,ip:127.0.0.1,dns:$SERVER_DNS_NAME.internal,ip:$SERVER_INTERNAL_IP,dns:$SERVER_DNS_NAME,ip:$SERVER_EXTERNAL_IP;

if [ "$IMPORT_CERT_CHAIN_IN_JKS" == "yes" ]; then
    echo "Import CA Cert into $CERT_FILE_PREFIX Keystore"
    keytool -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias $SERVER_CA_ALIAS -file $SERVER_CA_CERT_FILE_NAME -noprompt;

    echo "Import $CERT_FILE_PREFIX Cert into $CERT_FILE_PREFIX Keystore"
    keytool -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias $CERT_FILE_PREFIX -file $CERT_FILE_PREFIX.crt;
fi

if [ "$GEN_PRIVATE_KEY" == "yes" ]; then
    openssl pkcs12 -passin pass:$STORE_PASS -in $CERT_FILE_PREFIX-keystore.p12 -out $CERT_FILE_PREFIX-private-key.key -nodes -nocerts
fi
