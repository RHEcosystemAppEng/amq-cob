# Red Hat AMQ HA & DR Basic Topology

## References
* [Red Hat Design Document](https://drive.google.com/file/d/1RI9HjoUcB1-82y798Jfiq0ZQilbOiTwW/view?usp=sharing)
* [Clustering & HA with Shared Storage](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/manualconfig/ha-sharedstore-nfs)
* [Red Hat AMQ Official Documentation](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q4/html-single/introducing_red_hat_amq_7/index)
* [JGroups Example Configuration](https://github.com/apache/activemq-artemis/tree/main/examples/features/clustered/clustered-jgroups/src/main/resources/activemq/server0)
* [IBM Cloud VPC Interconnectivity](https://cloud.ibm.com/docs/vpc?topic=vpc-interconnectivity)

## Site 1 - TOR Setup

### Broker Setup
#### Prerequisites
* NFS Server is setup and available for use by the brokers, procedure can be found [here](#appendix-3---nfs-server-setup-on-rhel8)

#### Initial Broker Setup with Shared Storage
* Follow the instructions given [here](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/manualconfig/ha-sharedstore-nfs) to complete an initial setup
* Then go ahead and perform following modifications

#### Master Broker Setup

<details>
    <summary>Configuration - broker.xml</summary>
    
* Specific notes:
    * This instance is designated as the master
    * \<paging-directory\>, \<bindings-directory\>, \<journal-directory\>, \<large-messages-directory\> elements point to directories on NFS Server
    * The sample configuration makes use of SampleQueue

```xml
<?xml version='1.0'?>

<configuration xmlns="urn:activemq"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xi="http://www.w3.org/2001/XInclude"
               xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">

   <core xmlns="urn:activemq:core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="urn:activemq:core ">

   <broker-connections>
      <!-- Mirror to WDC Master  -->
      <amqp-connection uri="tcp://10.241.0.6:5672" name="WDC01">
         <mirror/>
      </amqp-connection>
      <!-- Mirror to WDC Slave -->
      <amqp-connection uri="tcp://10.241.64.6:5672" name="WDC01">
         <mirror/>
      </amqp-connection>
    </broker-connections>

    <security-enabled>false</security-enabled>

    <paging-directory>/mnt/broker-storage/amq/one/data/paging</paging-directory>
    <bindings-directory>/mnt/broker-storage/amq/one/data/bindings</bindings-directory>
    <journal-directory>/mnt/broker-storage/amq/one/data/journal</journal-directory>
    <large-messages-directory>/mnt/broker-storage/amq/one/data/large-messages</large-messages-directory>


    <ha-policy>
      <shared-store>
        <master>
          <failover-on-shutdown>true</failover-on-shutdown>
        </master>
      </shared-store>
    </ha-policy>

    <connectors>
      <connector name="netty-connector">tcp://10.249.0.4:61617</connector>
    </connectors>
    
    <acceptors>
      <acceptor name="netty-acceptor">tcp://10.249.0.4:61617</acceptor>
 <!-- AMQP Acceptor. Listens on default AMQP port for AMQP traffic -->
      <acceptor name="amqp">tcp://10.249.0.4:5672?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;protocols=AMQP;useEpoll=true;amqpCredits=1000;amqpLowCredits=300</acceptor>
    </acceptors>
    
      <broadcast-groups>
         <broadcast-group name="my-broadcast-group">
            <broadcast-period>5000</broadcast-period>
            <jgroups-file>jgroups-ping.xml</jgroups-file>
            <jgroups-channel>active_broadcast_channel</jgroups-channel>
            <connector-ref>netty-connector</connector-ref>
         </broadcast-group>
      </broadcast-groups>

      <discovery-groups>
         <discovery-group name="my-discovery-group">
            <jgroups-file>jgroups-ping.xml</jgroups-file>
            <jgroups-channel>active_broadcast_channel</jgroups-channel>
            <refresh-timeout>10000</refresh-timeout>
         </discovery-group>
      </discovery-groups>

    <cluster-user>some_cluster_user</cluster-user>
    <cluster-password>some_amq_cluster_password</cluster-password>

      <cluster-connections>
         <cluster-connection name="my-cluster">
            <connector-ref>netty-connector</connector-ref>
            <retry-interval>500</retry-interval>
            <use-duplicate-detection>true</use-duplicate-detection>
            <message-load-balancing>STRICT</message-load-balancing>
            <max-hops>1</max-hops>
            <discovery-group-ref discovery-group-name="my-discovery-group"/>
         </cluster-connection>
      </cluster-connections>

      <security-settings>
         <!--security for example queue-->
         <security-setting match="SampleQueue">
            <permission roles="amq" type="createDurableQueue"/>
            <permission roles="amq" type="deleteDurableQueue"/>
            <permission roles="amq" type="createNonDurableQueue"/>
            <permission roles="amq" type="deleteNonDurableQueue"/>
            <permission roles="amq" type="consume"/>
            <permission roles="amq" type="send"/>
            <permission type="createAddress" roles="amq"/>
            <permission type="deleteAddress" roles="amq"/>
            <permission type="browse" roles="amq"/>
            <!-- we need this otherwise ./artemis data imp wouldn't work -->
            <permission type="manage" roles="amq"/>
         </security-setting>
      </security-settings>

      <addresses>
         <address name="SampleQueue">
            <anycast>
               <queue name="SampleQueue" />
            </anycast>
         </address>
      </addresses>

   </core>
</configuration>


```    
</details>

<details>
    <summary>Configuration - jgroups-ping.xml</summary>

* Create jgroups-ping.xml file and paste the following contents
```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="urn:org:jgroups"
        xsi:schemaLocation="urn:org:jgroups http://www.jgroups.org/schema/jgroups.xsd">
     <TCP loopback="false"
	 bind_addr="<Master broker internal IP>"
         bind_port="7800"
         use_send_queues="true"
         recv_buf_size="${tcp.recv_buf_size:5M}"
         send_buf_size="${tcp.send_buf_size:5M}"
         max_bundle_size="64K"
         max_bundle_timeout="30"
         sock_conn_timeout="300"

         timer_type="new3"
         timer.min_threads="4"
         timer.max_threads="10"
         timer.keep_alive_time="3000"
         timer.queue_max_size="500"

         thread_pool.enabled="true"
         thread_pool.min_threads="2"
         thread_pool.max_threads="8"
         thread_pool.keep_alive_time="5000"
         thread_pool.queue_enabled="true"
         thread_pool.queue_max_size="10000"
         thread_pool.rejection_policy="discard"

         oob_thread_pool.enabled="true"
         oob_thread_pool.min_threads="1"
         oob_thread_pool.max_threads="8"
         oob_thread_pool.keep_alive_time="5000"
         oob_thread_pool.queue_enabled="false"
         oob_thread_pool.queue_max_size="100"
         oob_thread_pool.rejection_policy="discard"/>

    <!-- a location that can be found by both server's running -->
    <FILE_PING location="/mnt/broker-storage"/>
    <MERGE3  min_interval="10000"
             max_interval="30000"/>
    <FD_SOCK/>
    <FD timeout="3000" max_tries="3" />
    <VERIFY_SUSPECT timeout="1500"  />
    <BARRIER />
    <pbcast.NAKACK2 use_mcast_xmit="false"
                    discard_delivered_msgs="true"/>
    <UNICAST3 />
    <pbcast.STABLE stability_delay="1000" desired_avg_gossip="50000"
                   max_bytes="4M"/>
    <pbcast.GMS print_local_addr="true" join_timeout="2000"
                view_bundling="true"/>
    <MFC max_credits="2M"
         min_threshold="0.4"/>
    <FRAG2 frag_size="60K"  />
    <!--RSVP resend_interval="2000" timeout="10000"/-->
    <pbcast.STATE_TRANSFER/>
</config>
```
</details>

<details>
    <summary>Configuration - bootstrap.xml</summary>

* Edit the bootstrap.xml configuration and update the bind address with the VM local IP
```xml
 <web bind="http://<Master broker internal IP>:8161" path="web">
```
</details>

<details>
    <summary>Configuration - jolokia-access.xml</summary>

* Comment out the <strict-checking> element as follows, so the web console can work properly
```xml
<!-- <strict-checking/> -->
```
</details>

#### Slave Broker Setup

<details>
    <summary>Configuration - broker.xml</summary>
    
* Specific notes:
    * This instance is designated as the slave
    * \<paging-directory\>, \<bindings-directory\>, \<journal-directory\>, \<large-messages-directory\> elements point to directories on NFS Server
    * The sample configuration makes use of SampleQueue

```xml
<?xml version='1.0'?>

<configuration xmlns="urn:activemq"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xi="http://www.w3.org/2001/XInclude"
               xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">

   <core xmlns="urn:activemq:core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="urn:activemq:core ">

   <broker-connections>
      <!-- Mirror to WDC Master -->
      <amqp-connection uri="tcp://10.241.0.6:5672" name="WDC">
         <mirror/>
      </amqp-connection>
      <!-- Mirror to WDC Slave -->
      <amqp-connection uri="tcp://10.241.64.6:5672" name="WDC">
         <mirror/>
      </amqp-connection>
   </broker-connections>

    <security-enabled>false</security-enabled>

    <paging-directory>/mnt/broker-storage/amq/one/data/paging</paging-directory>
    <bindings-directory>/mnt/broker-storage/amq/one/data/bindings</bindings-directory>
    <journal-directory>/mnt/broker-storage/amq/one/data/journal</journal-directory>
    <large-messages-directory>/mnt/broker-storage/amq/one/data/large-messages</large-messages-directory>
 
    <connectors>
      <connector name="netty-connector">tcp://10.249.64.7:61617</connector>
    </connectors>
    
    <acceptors>
      <acceptor name="netty-acceptor">tcp://10.249.64.7:61617</acceptor>
 <!-- AMQP Acceptor. Listens on default AMQP port for AMQP traffic -->
      <acceptor name="amqp">tcp://10.249.64.7:5672?tcpSendBufferSize=1048576;tcpReceiveBufferSize=1048576;protocols=AMQP;useEpoll=true;amqpCredits=1000;amqpLowCredits=300</acceptor>
    </acceptors>

    <ha-policy>
      <shared-store>
          <slave>
            <failover-on-shutdown>true</failover-on-shutdown>
          </slave>
      </shared-store>
    </ha-policy>

      <broadcast-groups>
         <broadcast-group name="my-broadcast-group">
            <broadcast-period>5000</broadcast-period>
            <jgroups-file>jgroups-ping.xml</jgroups-file>
            <jgroups-channel>active_broadcast_channel</jgroups-channel>
            <connector-ref>netty-connector</connector-ref>
         </broadcast-group>
      </broadcast-groups>

      <discovery-groups>
         <discovery-group name="my-discovery-group">
            <jgroups-file>jgroups-ping.xml</jgroups-file>
            <jgroups-channel>active_broadcast_channel</jgroups-channel>
            <refresh-timeout>10000</refresh-timeout>
         </discovery-group>
      </discovery-groups>

      <cluster-user>some_cluster_user</cluster-user>
      <cluster-password>some_amq_cluster_password</cluster-password>

      <cluster-connections>
         <cluster-connection name="my-cluster">
            <connector-ref>netty-connector</connector-ref>
            <retry-interval>500</retry-interval>
            <use-duplicate-detection>true</use-duplicate-detection>
            <message-load-balancing>STRICT</message-load-balancing>
            <max-hops>1</max-hops>
            <discovery-group-ref discovery-group-name="my-discovery-group"/>
         </cluster-connection>
      </cluster-connections>

      <!-- Other config -->
      <security-settings>
         <!--security for example queue-->
         <security-setting match="SampleQueue">
            <permission roles="amq" type="createDurableQueue"/>
            <permission roles="amq" type="deleteDurableQueue"/>
            <permission roles="amq" type="createNonDurableQueue"/>
            <permission roles="amq" type="deleteNonDurableQueue"/>
            <permission roles="amq" type="consume"/>
            <permission roles="amq" type="send"/>
            <permission type="createAddress" roles="amq"/>
            <permission type="deleteAddress" roles="amq"/>
            <permission type="browse" roles="amq"/>
            <!-- we need this otherwise ./artemis data imp wouldn't work -->
            <permission type="manage" roles="amq"/>

         </security-setting>
      </security-settings>
    
      <addresses>
         <address name="SampleQueue">
            <anycast>
               <queue name="SampleQueue" />
            </anycast>
         </address>
      </addresses>

   </core>
</configuration>

```    
</details>

<details>
    <summary>Configuration - jgroups-ping.xml</summary>

* Create jgroups-ping.xml file and paste the following contents
```xml
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="urn:org:jgroups"
        xsi:schemaLocation="urn:org:jgroups http://www.jgroups.org/schema/jgroups.xsd">
     <TCP loopback="false"
	 bind_addr="<Slave broker internal IP>"
         bind_port="7800"
         use_send_queues="true"
         recv_buf_size="${tcp.recv_buf_size:5M}"
         send_buf_size="${tcp.send_buf_size:5M}"
         max_bundle_size="64K"
         max_bundle_timeout="30"
         sock_conn_timeout="300"

         timer_type="new3"
         timer.min_threads="4"
         timer.max_threads="10"
         timer.keep_alive_time="3000"
         timer.queue_max_size="500"

         thread_pool.enabled="true"
         thread_pool.min_threads="2"
         thread_pool.max_threads="8"
         thread_pool.keep_alive_time="5000"
         thread_pool.queue_enabled="true"
         thread_pool.queue_max_size="10000"
         thread_pool.rejection_policy="discard"

         oob_thread_pool.enabled="true"
         oob_thread_pool.min_threads="1"
         oob_thread_pool.max_threads="8"
         oob_thread_pool.keep_alive_time="5000"
         oob_thread_pool.queue_enabled="false"
         oob_thread_pool.queue_max_size="100"
         oob_thread_pool.rejection_policy="discard"/>

    <!-- a location that can be found by both server's running -->
    <FILE_PING location="/mnt/broker-storage"/>
    <MERGE3  min_interval="10000"
             max_interval="30000"/>
    <FD_SOCK/>
    <FD timeout="3000" max_tries="3" />
    <VERIFY_SUSPECT timeout="1500"  />
    <BARRIER />
    <pbcast.NAKACK2 use_mcast_xmit="false"
                    discard_delivered_msgs="true"/>
    <UNICAST3 />
    <pbcast.STABLE stability_delay="1000" desired_avg_gossip="50000"
                   max_bytes="4M"/>
    <pbcast.GMS print_local_addr="true" join_timeout="2000"
                view_bundling="true"/>
    <MFC max_credits="2M"
         min_threshold="0.4"/>
    <FRAG2 frag_size="60K"  />
    <!--RSVP resend_interval="2000" timeout="10000"/-->
    <pbcast.STATE_TRANSFER/>
</config>
```
</details>

<details>
    <summary>Configuration - bootstrap.xml</summary>

* Edit the bootstrap.xml configuration and update the bind address with the VM local IP
```xml
 <web bind="http://<Slave broker internal IP>:8161" path="web">
```
</details>

<details>
    <summary>Configuration - jolokia-access.xml</summary>

* Comment out the \<strict-checking\> element as follows, so the web console can work properly
```xml
<!-- <strict-checking/> -->
```
</details>

#### Start the brokers
```shell
ssh root@<Master broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run

ssh root@<Slave broker floating IP>;
/var/opt/amq-broker/broker-01/bin/artemis run
```

### Interconnect Setup
* Setup Red Hat Interconnect Router with the guide given [here](https://access.redhat.com/documentation/en-us/red_hat_amq/7.6/html/using_amq_interconnect/getting-started-router-rhel#installing-router-linux-getting-started)

* Configure the interconnect router as shown here
<details>
    <summary>Configuration - /etc/qpid-dispatch/qdrouterd.conf</summary>

* Add the following configuration in the start of the file

```text
# CONNECTOR FOR THE MASTER BROKER
connector {
    name: broker-connector-01
    host: <Master Broker Internal IP>
    port: 61617
    role: route-container
}

# ADDRESS FOR THE BROKER
address {
    prefix: SampleQueue
    waypoint: yes
}

# AUTOLINKS FOR THE BROKER
autoLink {
    address: SampleQueue
    connection: broker-connector-01
    direction: in
}

autoLink {
    address: SampleQueue
    connection: broker-connector-01
    direction: out
}
```
</details>

* Use the following command to start the Interconnect router
```shell
qdrouterd
```

## Site 2 - WDC setup

* Perform the same steps as given for Site 1 and substitute appropriate values for IP addresses, Site names and ports, as applicable in the placeholders in the configuration

## Create Test Sender and Receiver Clients on Router VMs

### Site 1 - TOR Setup
#### Prerequisites
* Red Hat AMQ Interconnect Python Client Library is installed, procedure can be found [here](https://access.redhat.com/documentation/en-us/red_hat_amq/7.6/html-single/using_the_amq_python_client/index#installing_on_red_hat_enterprise_linux)

#### Sender Client
* Log into the Router and create sender.py file in example directory
    ```shell
        ssh root@<Router IP>
        cd /usr/share/proton/examples/python/
        vi sender.py
    ```

<details>
    <summary>Paste this sender client code</summary>

```python
from __future__ import print_function

import sys

from proton import Message
from proton.handlers import MessagingHandler
from proton.reactor import Container

class SendHandler(MessagingHandler):
    def __init__(self, conn_url, address, message_body):
        super(SendHandler, self).__init__()

        self.conn_url = conn_url
        self.address = address
        self.message_body = message_body

    def on_start(self, event):
        conn = event.container.connect(self.conn_url)

        # To connect with a user and password:
        # conn = event.container.connect(self.conn_url, user="<user>", password="<password>")

        event.container.create_sender(conn, self.address)

    def on_link_opened(self, event):
        print("SEND: Opened sender for target address '{0}'".format
              (event.sender.target.address))

    def on_sendable(self, event):
        message = Message(self.message_body)
        event.sender.send(message)

        print("SEND: Sent message '{0}'".format(message.body))

        event.sender.close()
        event.connection.close()

def main():
    try:
        conn_url, address, message_body = sys.argv[1:4]
    except ValueError:
        sys.exit("Usage: send.py <connection-url> <address> <message-body>")

    handler = SendHandler(conn_url, address, message_body)
    container = Container(handler)
    container.run()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
```

</details>

#### Receiver Client
* Create receiver.py file in example directory
    ```shell
        vi receiver.py
    ```
<details>
    <summary>Paste this receiver client code</summary>

```python
from __future__ import print_function

import sys

from proton.handlers import MessagingHandler
from proton.reactor import Container

class ReceiveHandler(MessagingHandler):
    def __init__(self, conn_url, address, desired):
        super(ReceiveHandler, self).__init__()

        self.conn_url = conn_url
        self.address = address
        self.desired = desired
        self.received = 0

    def on_start(self, event):
        conn = event.container.connect(self.conn_url)

        # To connect with a user and password:
        # conn = event.container.connect(self.conn_url, user="<user>", password="<password>")

        event.container.create_receiver(conn, self.address)

    def on_link_opened(self, event):
        print("RECEIVE: Created receiver for source address '{0}'".format
              (self.address))

    def on_message(self, event):
        message = event.message

        print("RECEIVE: Received message '{0}'".format(message.body))

        self.received += 1

        if self.received == self.desired:
            event.receiver.close()
            event.connection.close()

def main():
    try:
        conn_url, address = sys.argv[1:3]
    except ValueError:
        sys.exit("Usage: receive.py <connection-url> <address> [<message-count>]")

    try:
        desired = int(sys.argv[3])
    except (IndexError, ValueError):
        desired = 0

    handler = ReceiveHandler(conn_url, address, desired)
    container = Container(handler)
    container.run()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
```
</details>

### Site 2 - WDC Setup
* Repeat the steps above for the WDC site

### Test the setup by running the receiver and sender

#### Start the receivers for both sites
* Run the receiver program on Router VM of both the sites
```shell
ssh root@<Site 1 Router IP>
cd /usr/share/proton/examples/python/; 
python3 receiver.py amqp://localhost SampleQueue;

ssh root@<Site 2 Router IP>
cd /usr/share/proton/examples/python/; 
python3 receiver.py amqp://localhost SampleQueue;
```

#### Send test messages from Site 1
* Login to the Site 1 Router VM and send the test messages as follows
```shell
ssh root@<Site 1 Router IP>
cd /usr/share/proton/examples/python/; 
python3 sender.py amqp://localhost SampleQueue TOR_hello_1;  python3 sender.py amqp://localhost SampleQueue TOR_hello_2;
```
* The receivers in both sites should show the messages sent above in the terminal window

#### Send test messages from Site 2
* Login to the Site 2 Router VM and send the test messages as follows
```shell
ssh root@<Site 2 Router IP>
cd /usr/share/proton/examples/python/; 
python3 sender.py amqp://localhost SampleQueue WDC_hello_1;  python3 sender.py amqp://localhost SampleQueue WDC_hello_2;
```
* The receivers in both sites should show the messages sent above in the terminal window

## Appendix 1 - IBM Cloud Core Component Inventory
### IBM Cloud VPCs
| VPC Name | Region | IP Subnets |
|---|---|---|
|rhkp-cob-amq-vpc|TOR|10.249.0.0/24, 10.249.64.0/24, 10.249.128.0/24|
|rhkp-wdc-cob-amq-vpc|WDC|10.241.0.0/24, 10.241.64.0/24, 10.241.128.0/24|

### IBM Cloud Transit Gateways
|Name|Region|Comment|
|---|---|---|
|rhkp-tor-cob-global-gateway|TOR|Connect two VPCs in TOR and WDC|

### TOR - IBM Cloud VM Details
|VM Name| Region| Availability Zone|Internal IP|Comment|
|---|---|---|---|---|
|rhkp-tor1-broker-01|TOR|1|10.249.0.4|Red Hat AMQ Broker 01|
|rhkp-tor2-broker-02|TOR|2|10.249.64.7|Red Hat AMQ Broker 02|
|rhkp-tor2-nfs-server-01|TOR|2|10.249.64.8|NFS Server for shared storage|
|rhkp-tor3-router-01|TOR|3|10.249.128.4|Red Hat Interconnect Router|

### WDC - IBM Cloud VM Details
|VM Name| Region| Availability Zone|Internal IP|Comment|
|---|---|---|---|---|
|rhkp-wdc1-broker-01|WDC|1|10.241.0.6|Red Hat AMQ Broker 01|
|rhkp-wdc2-broker-02|WDC|2|10.241.64.6|Red Hat AMQ Broker 02|
|rhkp-wdc2-nfs-server-01|WDC|2|10.241.64.4|NFS Server for shared storage|
|rhkp-wdc3-router-01|WDC|3|10.241.128.4|Red Hat Interconnect Router|

## Appendix 2 - RHEL8 Registration on IBM Cloud RHEL8
### Issue description
* IBM Cloud RHEL8 image is a minimal installation of RHEL8 
* The RHEL8 is by default registered with IBM Cloud registration
* Many key RHEL8 components such as Red Hat Interconnect router are unavailable with this subscription 
* To enable the specific packages one must register RHEL8 with appropriate credentials

### Commands to Register RHEL8
```shell
subscription-manager remove --all
subscription-manager unregister
subscription-manager clean
mv /etc/rhsm/rhsm.conf /etc/rhsm/rhsm.conf.sat-backup
mv /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf
sudo subscription-manager register --username <your-acc>\ --password <your-password> --auto-attach
```

## Appendix 3 - NFS Server Setup on RHEL8
### Server VM Instructions
* Install nfs utils packages on RHEL8 
```shell
sudo dnf install nfs-utils -y;
```

* Setup NFS Server to start as a service
```shell
sudo systemctl start nfs-server.service;
sudo systemctl enable nfs-server.service;
sudo systemctl status nfs-server.service;
rpcinfo -p | grep nfs;
```

* Create shared directory and change ownerships and restart the NFS server service
```shell
sudo mkdir -p /mnt/shared/brokers/;
sudo chown -R nobody: /mnt/shared/brokers/;
sudo chmod -R 777 /mnt/shared/brokers/;
sudo systemctl restart nfs-utils.service;
```

* Edit the exports file and provide access to client IPs or client IP ranges
```shell
sudo vi /etc/exports
```

* Add the following lines with IPs of clients who will access the shared directories. You can use IP CIDR ranges as well
```text
/mnt/shared/brokers 10.249.64.6(rw,sync,no_all_squash,root_squash)
/mnt/shared/brokers 10.249.64.7(rw,sync,no_all_squash,root_squash)
/mnt/shared/brokers 10.64.0.0/24(rw,sync,no_all_squash,root_squash)
```

* Export the settings changed above and make a quick confirmation
```shell
sudo exportfs -arv;
netstat -taupel | grep mountd;
netstat -taupel | grep rpc;
netstat -taupel | grep nfs;
```

### NFS Client Instructions

* Install NFS Utilities
```shell
sudo dnf install nfs-utils nfs4-acl-tools -y;
```

* Check the mounts available on NFS Server
```shell
showmount -e <NFS Server IP>;
```

* Create client directory and mount to server directory
```shell
sudo mkdir /mnt/broker-storage;
sudo mount -t nfs <NFS Server IP>:/mnt/shared/brokers /mnt/broker-storage/;
sudo mount | grep -i nfs;
```

* Edit the fstab file and add entry as follows
```shell
vi  /etc/fstab
```

```text
<NFS Server IP>:/mnt/shared/brokers /mnt/broker-storage/ nfs  defaults  0  0
```
* Verify you can create a test file and list the directory
```shell
sudo touch /mnt/broker-storage/text.txt
ll /mnt/broker-storage/
```

## Appendix 4 - IBM Cloud connectivity between VMs

### VMs in two separate VPCs
* For two VMs to connect, which belong in two separate VPCs (e.g WDC VPC and TOR VPC) in two separate Regions (e.g. TOR and WDC), one needs to use Global Transit Gateway in IBM Cloud

#### Create Global Transit Gateway
* Click Create Resource -> Select Network check box -> Interconnectivity -> Transit Gatewat -> Click Create 
* In the Transit Gateway page, provide Transit gateway name & select Resource group.
* Be sure to select Global Routing option
* Select Toronto as deployment location
* Under Connection 1 -> choose VPC -> leave Connection reach as is -> choose Region Washington DC
* When Available Connection is enabled, select VPC e.g. rhkp-wdc-cob-amq-vpc
* Click Create

#### Update Security Groups
* TOR Brokers and WDC Brokers are making use of mirroring on ports 5672(default amqp port)
* So create Inbound Rules as follows where TOR VMs can get incoming connections from ports 5672(default amqp port) from WDC Brokers.
* TOR Inbound rules
    * Click VPC Infrastructure -> Security groups -> Security group for Site 1 VPC
    * Click Rules tab
    * Click Add button under Inbound rules
    * In the Create inbound rule dialog, choose Protocol=TCP, Source type=IP Address
    * Enter the value 10.241.0.6 click Save
    * Create another same rule but with IP 10.241.64.6
    * This should allow inbound mirroring connections from brokers in the WDC sites
* WDC Inbound rules
    * Create Inbound rules as we did for TOR sites for each one of the TOR IPs: 10.249.0.4, 10.249.64.7.