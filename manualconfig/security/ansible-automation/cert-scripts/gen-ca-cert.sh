#!/bin/sh

# Simple script to gen CA Certs e.g. for Dev and Test purposes
# Change the variables below directly for specific use cases

# Default variables and values
KEY_PASS=redhat 
STORE_PASS=redhat 
CA_VALIDITY=3650 
SERVER_CA_ALIAS=server-ca
CERT_FILE_PREFIX=server-ca
KEY_SIZE=2048 
ORG_UNIT=Artemis
ORG=ActiveMQ
CANONICAL_NAME="ActiveMQ Artemis Server Certification Authority"
SERVER_CA_CERT_FILE_NAME=server-ca.crt

echo "Generating CA Cert"
keytool -storetype pkcs12 -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -alias $SERVER_CA_ALIAS -genkey -keyalg "RSA" -keysize $KEY_SIZE -sigalg sha384WithRSA -dname "CN=$CANONICAL_NAME, OU=$ORG_UNIT, O=$ORG" -validity $CA_VALIDITY -ext bc:c=ca:true,pathlen:0  -startdate -1m;

echo "Exporting CA Cert"
keytool -storetype pkcs12 -keystore $CERT_FILE_PREFIX-keystore.p12 -storepass $STORE_PASS -alias $SERVER_CA_ALIAS -exportcert -rfc > $SERVER_CA_CERT_FILE_NAME;

echo "Create Trust Store with CA Cert for use by $CERT_FILE_PREFIX"
keytool -keystore server-ca-truststore.p12 -storepass $STORE_PASS -keypass $KEY_PASS -importcert -alias $SERVER_CA_ALIAS -file $SERVER_CA_CERT_FILE_NAME -noprompt;