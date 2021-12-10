# Red Hat AMQ Interconnect Standalone Instance 

## Prerequisites
* A VM installed with RHEL8 is available for this installation.

## Installation Steps
* Launch terminal and subscribe to RHEL8 repos
```shell
sudo subscription-manager repos --enable=amq-interconnect-1-for-rhel-8-x86_64-rpms --enable=amq-clients-2-for-rhel-8-x86_64-rpms
```

* Alternately in some situations the following repositories may be needed
```shell
sudo subscription-manager repos --enable=interconnect-2-for-rhel-8-x86_64-rpms
sudo subscription-manager repos --enable=amq-clients-2-for-rhel-8-x86_64-rpms
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