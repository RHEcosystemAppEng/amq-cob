#!/bin/sh

### ******************************************************
### RUN THIS SCRIPT AS "amq_runner"
### ******************************************************

echo "Unregistering the system"
sudo subscription-manager remove --all
sudo subscription-manager unregister
sudo subscription-manager clean

echo "Creating backup for rhsm.conf and rhsm.conf.kat-backup..."
sudo cp /etc/rhsm/rhsm.conf /etc/rhsm/rhsm.conf.ORG
sudo cp /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf.kat-backup.ORG

echo "Overwriting rhsm.conf and rhsm.conf.kat-backup..."
sudo mv /etc/rhsm/rhsm.conf /etc/rhsm/rhsm.conf.sat-backup
sudo mv /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf

## ******************************************************************************
## note: CHANGE <USERNAME> AND <PASSWORD> TO CORRECT VALUE BEFORE RUNNING THIS SCRIPT
## ******************************************************************************
echo "Registering the system"
sudo subscription-manager register --username '<USERNAME>' --password '<PASSWORD>' --auto-attach

echo "Adding router repos..."
sudo subscription-manager repos --enable=interconnect-2-for-rhel-8-x86_64-rpms --enable=amq-clients-2-for-rhel-8-x86_64-rpms

echo "Installing router and tools..."
sudo dnf install qpid-dispatch-router qpid-dispatch-tools qpid-dispatch-console -y

echo "Changing ownership to amq_runner for /etc/qpid-dispatch dir"
sudo chown -R amq_runner:amq_runner /etc/qpid-dispatch