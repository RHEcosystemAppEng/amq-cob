# Red Hat AMQ Interconnect Standalone Instance 

## Prerequisites
* Installation of Oracle Virtualbox & Vagrant working

## Installation Steps
* Subscribe to RHEL8 repos
```shell
sudo subscription-manager repos --enable=amq-interconnect-1-for-rhel-8-x86_64-rpms --enable=amq-clients-2-for-rhel-8-x86_64-rpms
```

* Authenticate to subscription manager
```shell
sudo subscription-manager register --username <user name> --password <password>
```

* Install qpid packages with their dependencies & verify path for qdrouterd
```shell
sudo yum install qpid-dispatch-router qpid-dispatch-tools qpid-dispatch-console
which qdrouterd
```
## Installation of AMQ Python Client ( Not working on RHEL8 )

* Subscribe to RHEL8 repos
```shell
sudo subscription-manager repos --enable=amq-clients-2-for-rhel-8-x86_64-rpms
```

* Install Python Client Packages
```shell
sudo yum install python-qpid-proton python-qpid-proton-docs
```