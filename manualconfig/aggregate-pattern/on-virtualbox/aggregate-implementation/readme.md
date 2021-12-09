# Aggregate Pattern using AMQ Interconnect routers & brokers

## Vagrant environment for Producer, Consumer and Aggregate Routers
* Create the Vagrant file as covered
* Start the environment with
```shell
vagrant up
```
* Install AMQ Routers on each of Producer, Consumer and Aggregate by following the procedure given in standalone installation

## Configure Brokers VM
* Brokers VM is going to have two broker instances
* In the brokers VM first register the RHEL8 subscription
```shell
sudo subscription-manager register --username <user name> --password <password>
```
* Install Unzip & Java 8 Version
```shell
sudo yum install unzip java-1.8.0-openjdk
```

* Establish/run two cluster instances by following the corresponding procedure in amq-broker directory.

* Note: In this guide the cluster is configured and HA is not implemented for Brokers

* Open AMQP ports on the brokers VM so the Aggregate Router can send and receive messages
```shell
sudo firewall-cmd --add-port=5672/tcp;
sudo firewall-cmd --add-port=5772/tcp;
sudo firewall-cmd --runtime-to-permanent;
sudo firewall-cmd --list-ports;
```

## Configure Aggregate
* Install nano text editor to edit qdrouterd.conf file
```shell
vagrant ssh consumer
sudo yum install nano
sudo nano /etc/qpid-dispatch/qdrouterd.conf
```
* Update the router section as below to reflect that we are establishing a network of routers
```text
router {
    mode: interior 
    id: Router.A
}
```

* Define following listeners
```text
# Listener for Clients
listener {
    host: 0.0.0.0
    port: 5772
    authenticatePeer: no
    saslMechanisms: ANONYMOUS
}

# Listener for Inter-Router connections
listener {
    host: 0.0.0.0
    port: 5773
    authenticatePeer: no
    role: inter-router
}

# Listener for AMQ Console
listener {
    name: amq-console
    role: normal
    host: 0.0.0.0
    port: 5673
    http: yes
}
```

* Define following connectors for Brokers
```text
connector {
    name: broker-connector-1
    host: 192.168.56.33
    port: 5672
    role: route-container
    saslMechanisms: ANONYMOUS
}

connector {
    name: broker-connector-2
    host: 192.168.56.33
    port: 5772
    role: route-container
    saslMechanisms: ANONOYMOUS
}
```

* Define the Waypoint for the broker queue as follows
```text
# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
}
```
* Create autlinks for the broker queues for both broker 1 and broker 2
```text
# Create Autolink to send messages to the broker 1
autoLink {
    address: SampleQueue
    connection: broker-connector-1
    direction: out
}

autoLink {
    address: SampleQueue
    connection: broker-connector-1
    direction: in
}

# Create Autolink to send messages to the broker 2
autoLink {
    address: SampleQueue
    connection: broker-connector-2
    direction: in
}

autoLink {
    address: SampleQueue
    connection: broker-connector-2
    direction: out
}
```

* As the Aggregate is going to listen for incoming connections from producer and consumer, open the port 5001 
```shell
sudo firewall-cmd --add-port=5001/tcp;
sudo firewall-cmd --add-port=5772/tcp;
sudo firewall-cmd --add-port=5773/tcp;
sudo firewall-cmd --add-port=5673/tcp;
sudo firewall-cmd --runtime-to-permanent;
sudo firewall-cmd --list-ports;
```

* Start the router 
```shell
qdrouterd
```

## Configure Producer
* Install nano text editor to edit qdrouterd.conf file
```shell
vagrant ssh consumer
sudo yum install nano
sudo nano /etc/qpid-dispatch/qdrouterd.conf
```

* Update the router section as below to reflect that we are establishing a network of routers
```text
router {
    mode: interior 
    id: Router.P
}
```

* Add the client listeners as follows
```text
# Listener for Clients
listener {
    host: 0.0.0.0
    port: 5772
    authenticatePeer: no
    saslMechanisms: ANONYMOUS
}

# Listener for Inter-Router connections
listener {
    host: 0.0.0.0
    port: 5773
    authenticatePeer: no
    role: inter-router
}
```

* Add connector to aggregate
```text
# Connector to Aggregate
connector {
    name: aggregate-connector-1
    host: 192.168.56.32
    port: 5773
    role: inter-router
}
```

* Finally, add the Waypoint for the Broker queue
```text
# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    distribution: closest
}
```

* Open the following ports 
```shell
sudo firewall-cmd --add-port=5772/tcp;
sudo firewall-cmd --add-port=5773/tcp;
sudo firewall-cmd --runtime-to-permanent;
sudo firewall-cmd --list-ports;
```

* Start the router 
```shell
qdrouterd
```

## Configure Consumer
* Install nano text editor to edit qdrouterd.conf file
```shell
vagrant ssh consumer
sudo yum install nano
sudo nano /etc/qpid-dispatch/qdrouterd.conf
```

* Update the router section as below to reflect that we are establishing a network of routers
```text
router {
    mode: interior 
    id: Router.C
}
```

* Add the listeners as follows
```text
# Listener for Clients
listener {
        host: 0.0.0.0
        port: 5772
        authenticatePeer: no
        saslMechanisms: ANONYMOUS
}

# Listener for Inter-Router connections
listener {
        host: 0.0.0.0
        port: 5773
        authenticatePeer: no
        role: inter-router
}
```

* Add the connector section as follows to the qdrouterd.conf file
```text
connector {
    host: 192.168.56.32
    port: 5001
    role: inter-router
}
```

* Add the connector to the aggregate
```text
# Connector to Aggregate
connector {
    name: aggregagte-connector-1
    host: 192.168.56.32
    port: 5773
    role: inter-router
}
```

* Add a Waypoint for the Broker
```text
# Waypoint for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
}
```

* Open the following ports 
```shell
sudo firewall-cmd --add-port=5772/tcp;
sudo firewall-cmd --add-port=5773/tcp;
sudo firewall-cmd --runtime-to-permanent;
sudo firewall-cmd --list-ports;
```

* Start the router 
```shell
qdrouterd
```

## Configuring Message Queue Client VM
* In the brokers VM first register the RHEL8 subscription
```shell
sudo subscription-manager register --username <user name> --password <password>
```

* Install git
```shell
sudo dnf install git 
git --version
```

* Install Java 11 Version
```shell
sudo yum install java-11-openjdk
java -version
```

### Maven Installation
* Download Maven binary tar ball and extract 
```shell
wget https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz -P /tmp;

sudo tar xf /tmp/apache-maven-3.8.4-bin.tar.gz -C /opt;
sudo ln -s /opt/apache-maven-3.8.4 /opt/maven;
```

* Create /etc/profile.d/maven.sh file
```shell
sudo vi /etc/profile.d/maven.sh
```

* Paste the following contents in the /etc/profile.d/maven.sh file
```shell
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
```

* Grant execute permission and check Maven version
```shell
sudo chmod +x /etc/profile.d/maven.sh;
source /etc/profile.d/maven.sh;
mvn -version;
```

### Building and running Sender Code
* Clone Sender Git Repo, Compile & Run the Main Class
```shell
git clone https://github.com/mpaulgreen/amq-sender.git;
mvn compile exec:java -Dexec.mainClass="org.apache.qpid.jms.example.pubsub.Sender"
```

### Building and running Receiver Code
* Clone Sender Git Repo, Compile & Run the Main Class
```shell
git clone https://github.com/mpaulgreen/amq-receiver.git;
cd amq-receiver;
mvn compile exec:java -Dexec.mainClass="org.apache.qpid.jms.example.pubsub.Receiver";
```

## Known issue
* Currently broker 2 is running on port 5772 on the same broker VM as broker 1. There seems to be an issue where aggregate following error
```text
2021-12-09 15:51:37.641935 +0000 SERVER (info) [C13] Connection to 192.168.56.33:5772 failed: amqp:unauthorized-access Authentication failed [mech=none]
```
* Potential resolution of running the broker 2 in a separate VM instance with port 5672 needs to be tried to see if that error goes away.

