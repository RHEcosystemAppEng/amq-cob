# Installing a single AMQ Instance

## Prerequisites

## References
* [Using Red Hat AMQ Broker](https://access.redhat.com/documentation/en-us/red_hat_amq/7.2/html-single/using_amq_broker/index)

## Downloads
* [AMQ Broker 7.9](https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=102201)

## Install AMQ Broker
* Setup environment variables on Mac & ssh into Fedora Server for AMQ Broker
```shell
export AMQBROKER=192.168.56.107
ssh rhkp@$AMQBROKER
```

* Create a new user named amq-broker and provide it a password.
```shell
sudo useradd amq-broker;
sudo passwd amq-broker;
```

* Create the directory /opt/redhat/amq-broker and make the new amq-broker user and group the owners of it.
```shell
sudo mkdir /opt/redhat;
sudo mkdir /opt/redhat/amq-broker;
sudo chown -R amq-broker:amq-broker /opt/redhat/amq-broker;
```

* Copy the AMQ Broker zip archive to the AMQ Server 
```shell
scp ./downloads/amq-broker-7.9.0-bin.zip rhkp@$AMQBROKER:/home/rhkp
```

* Change the owner of the archive to the new user.
```shell
sudo chown amq-broker:amq-broker amq-broker-7.9.0-bin.zip
```

* Move the installation archive to the directory you just created.
```shell
sudo mv amq-broker-7.9.0-bin.zip /opt/redhat/amq-broker
```

* Authenticate to RHEL8 subscription manager
```shell
sudo subscription-manager register --username <user name> --password <password>
```

* Install Unzip and JDK on the host
```shell
sudo yum install unzip java-1.8.0-openjdk
```

* As the new amq-broker user, extract the contents by using the unzip command.
```shell
su - amq-broker;
cd /opt/redhat/amq-broker;
unzip amq-broker-7.9.0-bin.zip;
exit;
```

## Create a standalone Red Hat AMQ Broker Instance
* Create a directory for the broker instance and grant ownership to the amq-brker user.
```shell
sudo mkdir /var/opt/amq-broker;
sudo chown -R amq-broker:amq-broker /var/opt/amq-broker;
```

* Use the artemis create command to create the broker.
```shell
su - amq-broker;
cd /var/opt/amq-broker;
<install-dir>/bin/artemis create mybroker
```

* You can use following sample values for prompts, here I have used password: redhat 
```text
Creating ActiveMQ Artemis instance at: /var/opt/amq-broker/mybroker

--user: is a mandatory property!
Please provide the default username:
admin

--password: is mandatory with this configuration:
Please provide the default password:


--allow-anonymous | --require-login: is a mandatory property!
Allow anonymous access?, valid values are Y,N,True,False
Y

Auto tuning journal ...
done! Your system can make 50 writes per millisecond, your journal-buffer-timeout will be 20000
```

* Run the AMQ Broker Instance 
```shell
/var/opt/amq-broker/mybroker/bin/artemis run
```