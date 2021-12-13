
# Configuring AMQ Interconnect router in fan-out topology

* [Router configs](#router-configs)
  + [Router 1 config](#router-1-config)
  + [Router 2 config](#router-2-config)
  + [Router 3 config](#router-3-config)
* [Firewall settings](#firewall-settings)
* [Run the routers](#run-the-routers)
* [Prerequisite](#prerequisite)

In the fan-out topology, both producers and consumers will be connecting to the main (hub) router
which will fan-out the messages to two routers (spokes). Each of these two routers will be connected
to a live AMQ broker.

In this architecture, each of the component (router/broker) will be running on a separate VM.

_The configuration file for each of the router is_ `/etc/qpid-dispatch/qdrouterd.conf`.


## Router configs

### Router 1 config
This is the router which will serve producers and consumers. This router provides a 
few listeners to support incoming connections from consumer/producers as well
as other routers in the network.

* Change the `router` element in the config file to:
```shell
router {
    mode: interior
    id: router.fan-out-hub-01
}
```

* Add the config given below at the end of the config file


<details>
  <summary>Click to expand or collapse the config</summary>

```shell
# Listener for inter-router comm
listener {
    host: 0.0.0.0
    port: 5773
    authenticatePeer: no
    role: inter-router
}

# broker queue. Without this or with distribution set to balanced, all the messages
# ended up on one broker
address {
    prefix: exampleQueue
    waypoint: yes
    distribution: closest
}
```

</details>

---
### Router 2 config
Config for 2nd router that is connected to live broker 1.

* Change the `router` element in the config file to:
```shell
router {
    mode: interior
    id: router.to.live-broker-01
}
```

* Add the config given below at the end of the config file

<details>
  <summary>Click to expand or collapse the config</summary>

```shell

# Connection to the hub
connector {
    name: router.fan-out-hub-01
    # substitute with actual hostname (or ip address) of the hub/main router
    host: amq-interconn-01
    port: 5773
    role: inter-router
}

# Connection to the broker
connector {
    name: live-broker-01
    # substitute this with actual hostname (or ip address) of live broker 1
    host: amq-live-01
    port: 61616
    role: route-container
    saslMechanisms: ANONYMOUS
}

# router will use the queue specified in prefix
address {
    prefix: exampleQueue
    # waypoint address ensures the queue is identified on the broker
    waypoint: yes
}

# connect router to broker using autoLink
# inbound link => message(s) will flow into the router (broker queue -> router)
autoLink {
    address: exampleQueue
    connection: live-broker-01
    direction: in
}

# outbound link => message(s) will flow out of the router (router -> broker queue)
autoLink {
    address: exampleQueue
    connection: live-broker-01
    direction: out
}

```
</details>

---
### Router 3 config
Config for 3rd router that is connected to live broker 2.

* Change the `router` element in the config file to:
```shell
router {
    mode: interior
    id: router.to.live-broker-02
}
```

* Add the config given below at the end of the config file

<details>
  <summary>Click to expand or collapse</summary>

```shell

# Connection to the hub
connector {
    name: router.fan-out-hub-01
    # substitute with actual hostname (or ip address) of the hub/main router
    host: amq-interconn-01
    port: 5773
    role: inter-router
}

# Connection to the broker
connector {
    name: live-broker-02
    # substitute this with actual hostname (or ip address) of live broker 2
    host: amq-live-02
    port: 61616
    role: route-container
    saslMechanisms: ANONYMOUS
}

# router will use the queue specified in prefix
address {
    prefix: exampleQueue
    # waypoint address ensures the queue is identified on the broker
    waypoint: yes
}

# connect router to broker using autoLink
# inbound link => message(s) will flow into the router (broker queue -> router)
autoLink {
    address: exampleQueue
    connection: live-broker-02
    direction: in
}

# outbound link => message(s) will flow out of the router (router -> broker queue)
autoLink {
    address: exampleQueue
    connection: live-broker-02
    direction: out
}

```
</details>

---

## Firewall settings

* For main router (router 1), run following commands to open up the necessary ports

```shell
# Open the two ports (one for amqp and another for inter-router communication)
sudo firewall-cmd --permanent --add-port={5672,5773}/tcp

# Reload the firewall
sudo firewall-cmd --reload

# Display settings
sudo firewall-cmd --list-all
```

* For router 2 and 3, run following commands to open the required port

```shell
# Open the port for amqp
sudo firewall-cmd --permanent --add-port 5672/tcp

# Reload the firewall
sudo firewall-cmd --reload

# Display settings
sudo firewall-cmd --list-all

```

## Run the routers
Routers can be started in any order by running either of the following commands:
* `qdrouter`
  * Above command will start the router in the foreground
* `qdrouter -d`
  * Above command will start the router as a daemon process


* _By default the router listens on port 5672_
* Router config file that defines the router functions:
    * `/etc/qpid-dispatch/qdrouterd.conf`


## Prerequisite
* Must have installed the router, on each of the three VMs, following the instructions given in [router topology](../readme.md)
* Brokers must be running


_Most of the information provided here is taken from [AMQ Interconnect Router](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q2/html-single/using_the_amq_interconnect_router/index)_
