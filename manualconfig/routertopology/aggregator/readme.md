# Aggregate Pattern using AMQ Interconnect routers & brokers

## IPs used in this guide
|Component|IP|
|---|---|
|Producer|192.168.56.30|
|Consumer|192.168.56.31|
|Aggregate|192.168.56.32|
|Broker|192.168.56.33|

## Configure Aggregate
* Edit the qdrouterd.conf file
```shell
sudo vi /etc/qpid-dispatch/qdrouterd.conf
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

* Create autolinks for the broker queues for both broker 1 and broker 2
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

* As the Aggregate is going to listen for incoming connections from producer and consumer, open the needed ports
```shell
sudo firewall-cmd --permanent --add-port={5001,5772,5773,5673}/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

* Start the router 
```shell
qdrouterd
```

## Configure Producer
* Edit the qdrouterd.conf file
```shell
sudo vi /etc/qpid-dispatch/qdrouterd.conf
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

* Finally, add the Address for the Broker queue
```text
# Address for the Broker Queue
address {
    prefix: SampleQueue
    distribution: closest
}
```

* Open the following ports 
```shell
sudo firewall-cmd --permanent --add-port={5772,5773}/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

* Start the router 
```shell
qdrouterd
```

## Configure Consumer
* Edit the qdrouterd.conf file
```shell
sudo vi /etc/qpid-dispatch/qdrouterd.conf
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

    host: 192.168.56.32
* Add the connector to the aggregate
```text
# Connector to Aggregate
connector {
    name: aggregagte-connector-1
    port: 5773
    role: inter-router
}
```

* Add a address for the Broker
```text
# Address for the Broker Queue
address {
    prefix: SampleQueue
    waypoint: yes
}
```

* Open the following ports 
```shell
sudo firewall-cmd --permanent --add-port={5772,5773}/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

* Start the router 
```shell
qdrouterd
```