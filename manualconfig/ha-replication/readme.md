# Configuring HA replication

## Setup AMQ
### Create user and add to sudoers:
_This setup is done on RHEL 8.5_ 

Execute following command to create the user who will be running AMQ:

```shell
# create user
sudo adduser amq_runner

# Provide a new password for "amq_runner" user
sudo passwd amq_runner

# add "amq_runner" user to the sudo group
sudo usermod -aG wheel amq_runner
```

Verify whether the `amq_runner` user has sudo access:

```shell
su - amq_runner

# provide amq_runner passwd when prompted
sudo whoami
```

### Install Java 11
* Install Java 11 by running following command (_if java is not already installed_)
  * `sudo yum install java-11-openjdk`

### Install AMQ
* Install zip and unzip (_didn't find these utilities in my RHEL download_)
  * `sudo yum install zip unzip`

* Create AMQ install directory with correct access
  * _assuming the amq-broker zip has been downloaded to /tmp directory. If the location is different then please
    change the location in the command given below_
  ```shell
    sudo mkdir /opt/rh-amq-broker
    sudo chown -R amq_runner:amq_runner /opt/rh-amq-broker/
    sudo chown amq_runner:amq_runner /tmp/amq-broker-7.9.0-bin.zip
    sudo mv /tmp/amq-broker-7.9.0-bin.zip /opt/rh-amq-broker/

    # Directory where AMQ broker will be installed
    cd /opt/rh-amq-broker/
    unzip amq-broker-7.9.0-bin.zip > /dev/null
  ```

* Create broker instance(s) with correct access
  ```shell
    # install directory for brokers
    sudo mkdir /var/opt/amq-broker
    sudo chown amq_runner:amq_runner /var/opt/amq-broker/
    cd /var/opt/amq-broker/

    # create 1st broker instance - master 
    /opt/rh-amq-broker/amq-broker-7.9.0/bin/artemis create broker-01

    # create 2nd broker instance - master
    /opt/rh-amq-broker/amq-broker-7.9.0/bin/artemis create broker-02

    # create 3rd broker instance - slave (for broker1) 
    /opt/rh-amq-broker/amq-broker-7.9.0/bin/artemis create broker-03

    # create 4th broker instance - slave (for broker2)
    /opt/rh-amq-broker/amq-broker-7.9.0/bin/artemis create broker-04
  ```
  * Broker 1:
    * change the broker-01/etc/broker.xml by using the section from [broker 1 config](#broker-1-config)  
  * Broker 2:
    * change the broker-02/etc/broker.xml by using the section from [broker 2 config](#broker-2-config)
    * change the port in broker-02/etc/bootstrap.xml to 8162  
  * Broker 3:
    * change the broker-03/etc/broker.xml by using the section from [broker 3 config](#broker-3-config)
    * change the port in broker-03/etc/bootstrap.xml to 8163  
  * Broker 4:
    * change the broker-04/etc/broker.xml by using the section from [broker 4 config](#broker-4-config)
    * change the port in broker-04/etc/bootstrap.xml to 8164  

  * _When creating the broker instances, please provide following values_:
    * Default username: `amq_user`
    * Default password: `<PROVIDE_SOME_PASSWORD>`
    * Allow anonymous access: Y



### _All the brokers are running on a single VM, running `RHEL 8.5`_

Steps to create the cluster are taken
from [Red Hat AMQ Cluster setup](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html-single/configuring_amq_broker/index#setting-up-broker-cluster-configuring)
, but are provided in detail for each broker here.

* Broker1 - master
    * running on port `61616`
    * has master configuration in `broker.xml`
    * AMQ console is running at port 8161
* Broker2 - master
    * running on port `61617`
    * has slave configuration in `broker.xml`
    * AMQ console is running at port 8162
* Broker3 - slave (for broker1)
    * running on port `61618`
    * has master configuration in `broker.xml`
    * AMQ console is running at port 8163
* Broker4 - slave (for broker2)
    * running on port `61619`
    * has slave configuration in `broker.xml`
    * AMQ console is running at port 8164

Detailed configuration (inside config files) are provided in `config` directory, but the
main config part is also provided here. Replace the `<acceptors>...</acceptors>` element
with the config xml given below:

#### Broker 1 config:

<details>
  <summary>Click to expand or collapse</summary>

```xml
    <ha-policy>
      <replication>
        <master>
          <!--we need this for auto failback-->
          <check-for-live-server>true</check-for-live-server>
          <group-name>demo</group-name>
        </master>
      </replication>
    </ha-policy>
    
    <connectors>
      <connector name="artemis-connector">tcp://localhost:61616</connector>
    </connectors>
    
    <acceptors>
      <acceptor name="artemis-acceptor">tcp://0.0.0.0:61616</acceptor>
    </acceptors>
    
    <cluster-user>some_cluster_user</cluster-user>
    <cluster-password>some_amq_cluster_password</cluster-password>

    <broadcast-groups>
      <broadcast-group name="test-broadcast-grp">
        <local-bind-port>-1</local-bind-port>
        <group-address>231.7.7.7</group-address>
        <group-port>9876</group-port>
        <broadcast-period>5000</broadcast-period>
        <connector-ref>artemis-connector</connector-ref>
      </broadcast-group>
    </broadcast-groups>
    
    <discovery-groups>
      <discovery-group name="test-discovery-grp">
        <group-address>231.7.7.7</group-address>
        <group-port>9876</group-port>
        <refresh-timeout>10000</refresh-timeout>
      </discovery-group>
    </discovery-groups>
    
    <cluster-connections>
      <cluster-connection name="test-cluster">
        <connector-ref>artemis-connector</connector-ref>
        <discovery-group-ref discovery-group-name="test-discovery-grp"/>
      </cluster-connection>
    </cluster-connections>
```

</details>

#### Broker 2 config:

<details>
  <summary>Click to expand or collapse</summary>

```xml
     <ha-policy>
        <replication>
            <master>
                <!--we need this for auto failback-->
                <check-for-live-server>true</check-for-live-server>
                <group-name>demo</group-name>
            </master>
        </replication>
      </ha-policy>

      <connectors>
        <connector name="artemis-connector">tcp://localhost:61617</connector>
      </connectors>

      <acceptors>
         <acceptor name="artemis-acceptor">tcp://0.0.0.0:61617</acceptor>
      </acceptors>

      <cluster-user>some_cluster_user</cluster-user>
      <cluster-password>some_amq_cluster_password</cluster-password>

      <broadcast-groups>
        <broadcast-group name="test-broadcast-grp">
            <local-bind-port>-1</local-bind-port>
            <group-address>231.7.7.7</group-address>
            <group-port>9876</group-port>
            <broadcast-period>5000</broadcast-period>
            <connector-ref>artemis-connector</connector-ref>
        </broadcast-group>
      </broadcast-groups>

      <discovery-groups>
        <discovery-group name="test-discovery-grp">
            <group-address>231.7.7.7</group-address>
            <group-port>9876</group-port>
            <refresh-timeout>10000</refresh-timeout>
        </discovery-group>
      </discovery-groups>

      <cluster-connections>
        <cluster-connection name="test-cluster">
            <connector-ref>artemis-connector</connector-ref>
            <discovery-group-ref discovery-group-name="test-discovery-grp"/>
        </cluster-connection>
      </cluster-connections>
```

</details>

#### Broker 3 config:

<details>
  <summary>Click to expand or collapse</summary>

```xml
    <ha-policy>
      <replication>
        <slave>
          <!--we need this for auto failback-->
          <allow-failback>true</allow-failback>
          <group-name>demo</group-name>
        </slave>
      </replication>
    </ha-policy>

    <connectors>
      <connector name="artemis-connector">tcp://localhost:61618</connector>
      <connector name="artemis-live-connector">tcp://localhost:61616</connector>
    </connectors>

    <acceptors>
        <acceptor name="artemis-acceptor">tcp://0.0.0.0:61618</acceptor>
    </acceptors>
    
    <cluster-user>some_cluster_user</cluster-user>
    <cluster-password>some_amq_cluster_password</cluster-password>

    <broadcast-groups>
      <broadcast-group name="test-broadcast-grp">
        <local-bind-port>-1</local-bind-port>
        <group-address>231.7.7.7</group-address>
        <group-port>9876</group-port>
        <broadcast-period>5000</broadcast-period>
        <connector-ref>artemis-connector</connector-ref>
      </broadcast-group>
    </broadcast-groups>

    <discovery-groups>
      <discovery-group name="test-discovery-grp">
        <group-address>231.7.7.7</group-address>
        <group-port>9876</group-port>
        <refresh-timeout>10000</refresh-timeout>
      </discovery-group>
    </discovery-groups>

    <cluster-connections>
      <cluster-connection name="test-cluster">
        <connector-ref>artemis-connector</connector-ref>
        <discovery-group-ref discovery-group-name="test-discovery-grp"/>
      </cluster-connection>
    </cluster-connections>
```

</details>

#### Broker 4 config:

<details>
  <summary>Click to expand or collapse</summary>

```xml
     <ha-policy>
        <replication>
            <slave>
                <!--we need this for auto failback-->
                <allow-failback>true</allow-failback>
                <group-name>demo</group-name>
            </slave>
        </replication>
      </ha-policy>

      <connectors>
        <connector name="artemis-connector">tcp://localhost:61619</connector>
        <connector name="artemis-live-connector">tcp://localhost:61617</connector>
      </connectors>

      <acceptors>
         <acceptor name="artemis-acceptor">tcp://0.0.0.0:61619</acceptor>
      </acceptors>

      <cluster-user>some_cluster_user</cluster-user>
      <cluster-password>some_amq_cluster_password</cluster-password>

      <broadcast-groups>
        <broadcast-group name="test-broadcast-grp">
            <local-bind-port>-1</local-bind-port>
            <group-address>231.7.7.7</group-address>
            <group-port>9876</group-port>
            <broadcast-period>5000</broadcast-period>
            <connector-ref>artemis-connector</connector-ref>
        </broadcast-group>
      </broadcast-groups>

      <discovery-groups>
        <discovery-group name="test-discovery-grp">
            <group-address>231.7.7.7</group-address>
            <group-port>9876</group-port>
            <refresh-timeout>10000</refresh-timeout>
        </discovery-group>
      </discovery-groups>

      <cluster-connections>
        <cluster-connection name="test-cluster">
            <connector-ref>artemis-connector</connector-ref>
            <discovery-group-ref discovery-group-name="test-discovery-grp"/>
        </cluster-connection>
      </cluster-connections>
```

</details>


## Setup UDP on local box
To run multiple brokers in a cluster using UDP, you'll need to direct traffic meant for
`224.0.0.0` to the loopback interface. Please run following command to do so:

`sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_above info is from [Red Hat AMQ getting started - examples](https://access.redhat.com/documentation/en-us/red_hat_amq/7.0/html/using_amq_broker/getting_started#examples)_

> _You may need to run following command as well in case the UDP connectivity doesn't
work with the above command_

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`sudo ifconfig lo multicast`

### Persist the route
Above route will not survive a reboot of the system. Follow instructions given below to add a service
that will set the route for you at the startup

* Create a new systemd file by executing following command:
  * `sudo vi /etc/systemd/system/udp_loopback.service`
* Paste following text in it and save the file.

<details>
  <summary>Click to expand or collapse</summary>

```shell
[Unit]
Description=Create route for loopback (direct traffic meant for 224.0.0.0 to the loopback interface)
After=default.target

[Service]
type=onshot
ExecStart=/usr/local/sbin/udp_loopback_route.sh

[Install]
WantedBy=default.target
```

</details>

* Reload systemd daemon by executing following command:
  * `sudo systemctl daemon-reload`
* Enable the newly created service (`udp_loopback.service`) by executing following command:
  * `sudo systemctl enable udp_loopback`
    * _This should create a symlink_ 
* Create the route script by executing following command:
  * `sudo vi /usr/local/sbin/udp_loopback_route.sh`
* Paste following text in it and save the file:
```shell
#!/bin/sh
route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
```

* Change the permission of above script by running following command:
  * `sudo chmod 744 /usr/local/sbin/udp_loopback_route.sh`
* Reboot the system by running following command:
  * `sudo reboot now`
* After the system restarts, run following command:
* `route -n`
  * _You should see following entry in the output from above command_

```shell
 Destination     Gateway         Genmask         Flags Metric Ref    Use Iface  
 224.0.0.0       0.0.0.0         240.0.0.0       U     0      0        0 lo
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_Persist route info is from [Configure command/script to run at startup](https://access.redhat.com/solutions/1751263)_



## Run the brokers
```shell
./broker-01/bin/artemis run > broker1.out 2>&1 &
./broker-02/bin/artemis run > broker2.out 2>&1 &
./broker-03/bin/artemis run > broker3.out 2>&1 &
./broker-04/bin/artemis run > broker4.out 2>&1 &
```

