
# Configuring AMQ DR advanced topology 

* [Prerequisites](#prerequisites)
  * [Install Terraform](#install-terraform)
  * [Verify installation](#verify-installation)
  * [Download AMQ archive](#download-rhamq-archive-file)
  * [Checkout config](#checkout-setup-config)
  * [Create API key](#create-api-key-for-ibm-cloud)
  * [Create SSH key](#create-ssh-key-to-work-with-vpc)

<details>
<summary>Toronto - Cluster 1/Cluster 2</summary>

  * [Setup Region 1](#setup-region-1)
    * [Prerequisites](#prerequisites---region-1)
    * [Setup API key config](#setup-config-for-ibm-api-key)
    * [Setup Region 1 - automated step](#setup-region-1---automated-step)
    * Manual Steps
      * [Setup NFS servers](#setup-nfs-servers-region-1---manual-step)
      * Brokers
        * [Setup Broker1](#setup-broker1-region-1---manual-step)
        * [Setup Broker2 - Backup of Broker 1](#setup-broker2-region-1---manual-step)
        * [Setup Broker3](#setup-broker3-region-1---manual-step)
        * [Setup Broker4 - Backup of Broker 3](#setup-broker4-region-1---manual-step)
        * [Setup Broker5](#setup-broker5-region-1---manual-step)
        * [Setup Broker6 - Backup of Broker 5](#setup-broker6-region-1---manual-step)
        * [Setup Broker7](#setup-broker7-region-1---manual-step)
        * [Setup Broker8 - Backup of Broker 7](#setup-broker8-region-1---manual-step)
      * Routers
        * [Setup hub router](#setup-vpc1-hub-router-region-1---manual-step)
        * [Setup spoke router](#setup-vpc1-spoke-router-region-1---manual-step)
        * [Setup spoke router](#setup-vpc2-spoke-router-region-1---manual-step)

</details>

<details>
<summary>Dallas - Cluster 1/Cluster 2</summary>

  * [Setup Region 1](#setup-region-2)
    * [Prerequisites](#prerequisites---region-2)
    * [Setup Region 1 - automated step](#setup-region-2---automated-step)
    * Manual Steps
      * [Setup NFS servers](#setup-nfs-servers-region-2---manual-step)
      * Brokers
        * [Setup Broker1](#setup-broker1-region-2---manual-step)
        * [Setup Broker2 - Backup of Broker 1](#setup-broker2-region-2---manual-step)
        * [Setup Broker3](#setup-broker3-region-2---manual-step)
        * [Setup Broker4 - Backup of Broker 3](#setup-broker4-region-2---manual-step)
        * [Setup Broker5](#setup-broker5-region-2---manual-step)
        * [Setup Broker6 - Backup of Broker 5](#setup-broker6-region-2---manual-step)
        * [Setup Broker7](#setup-broker7-region-2---manual-step)
        * [Setup Broker8 - Backup of Broker 7](#setup-broker8-region-2---manual-step)
      * Routers
        * [Setup hub router](#setup-vpc1-hub-router-region-2---manual-step)
        * [Setup spoke router](#setup-vpc1-spoke-router-region-2---manual-step)
        * [Setup spoke router](#setup-vpc2-spoke-router-region-2---manual-step)

</details>

* [Transit Gateway setup](#transit-gateway-setup)


<details>
<summary>Run the setup</summary>

  * [Run brokers/routers](#running-brokers-and-routers)
    * [Cluster1](#cluster1---toronto-region)
    * [Cluster2](#cluster2---toronto-region)
    * [Cluster3](#cluster1---dallas-region)
    * [Cluster4](#cluster2---dallas-region)

</details>

<details>
<summary>Delete the setup</summary>

  * [Destroy the resources](#destroy-the-resources)
    * [Region 1](#destroy-resources---region-1)
    * [Region 2](#destroy-resources---region-2)

</details>

* [Common steps](#common-steps)
  * [Broker instance manual setup](#broker-instance-manual-setup)
  * [Edit broker file](#edit-brokerxml)
  * [Create JGroups file](#create-jgroups-pingxml)
  * [Edit bootstrap file](#edit-bootstrapxml)
* [Retrieving public IP](#retrieving-public-ip-for-instances)
  * [Retrieve public IP - Cluster1](#retrieve-instance-public-ip---cluster1)
  * [Retrieve public IP - Cluster2](#retrieve-instance-public-ip---cluster2)
  * [Retrieve public IP - Cluster3](#retrieve-instance-public-ip---cluster3)
  * [Retrieve public IP - Cluster4](#retrieve-instance-public-ip---cluster4)
* [Instance info](#instance-info)
* [References](#references)

Configuring AMQ advanced topology for DR, in **IBM Cloud**, following setup was used:
* Region 1 (Toronto)
  * Two clusters
  * Hub Router
  * Routers to connect to live brokers in each clusters
    * Hub and other routers are part of hub and spoke topology
  * Two sets of Live/Backup brokers running in different availability zones (AZs) in each cluster
* Region 2 (Dallas)
  * Two clusters
  * Hub Router
  * Routers to connect to live brokers in each clusters
    * Hub and other routers are part of hub and spoke topology
  * Two sets of Live/Backup brokers running in different availability zones (AZs) in each cluster


## Prerequisites

### Install Terraform
Please follow instructions to [install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) to
for your platform

### Verify installation
Run `terraform -help` command to verify that `terraform` is installed correctly

### Download RHAMQ archive file
* Download RedHat AMQ by following step at [Download AMQ Broker](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html/getting_started_with_amq_broker/installing-broker-getting-started#downloading-broker-archive-getting-started)
* Name the downloaded zip file `amq-broker-7.9.0-bin.zip` if it's not already named that

### Checkout Setup config
Clone this repo to setup brokers/routers in IBM Cloud:
* `git clone https://github.com/RHEcosystemAppEng/amq-cob.git`
* Open up a terminal and run following commands
  ```shell
  cd amq-cob/automation
  MAIN_CONFIG_DIR=`pwd`
  mkdir files
  ```
* Copy the downloaded AMQ archive to `files` direcctory (_created in previous step_)

### Create API key for IBM CLoud
* Create a new API key by following instructions at [Create API key](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui)
* Save the API key on your system as you'll need it later on to run Terraform config
  * _Please skip these steps if an API key is already created_

### Create SSH key to work with VPC
* Create a new SSH key by following instructions at [Create SSH key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)
  * _Please skip these steps if a SSH key is already created and added to the account_


<br>


## Setup Region 1
Region 1 is setup in **Toronto** that has two clusters:
* **Cluster1** - consisting of following four brokers:
  * `broker01` - live/primary
  * `broker02` - backup of broker01
  * `broker03` - live/primary
  * `broker04` - backup of broker03

* **Cluster2** - consisting of following four brokers:
  * `broker05` - live/primary
  * `broker06` - backup of broker05
  * `broker07` - live/primary
  * `broker08` - backup of broker07

As part of cluster1 config, following interconnect routers are also created and setup (in the same VPC):
* router01 - Hub router - accepts connections from consumers/producers
* router02 - Spoke router - connects to live brokers in Cluster1 and also to Hub router (router01)

As part of cluster2 config, following interconnect router is also created and setup (in the same VPC):
* router03 - Spoke router - connects to live brokers in Cluster2 and also to Hub router (router01) that is part of
  the config for Cluster1

#### Prerequisites - Region 1
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

<br>

### Setup config for IBM API key
* Create a file named `terraform.tfvars`, _in `$MAIN_CONFIG_DIR/files` directory_, with following content:
  ```shell
  ibmcloud_api_key = "<YOUR_IBM_CLOUD_API_KEY>"
  ssh_key = "<NAME_OF_YOUR_SSH_KEY>"
  ```
  _Substitute with your actual IBM Cloud API key here_

<br>

### Setup Region 1 - automated step
* Perform setup of region 1 (cluster1/cluster2) by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/toronto
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform init
  terraform apply -auto-approve -var PREFIX="cob-test"
  ```
  * _All resources created will have the PREFIX provided in the last command_
* Above command will take around 5-7 minutes and should create following resources:
  * **VPC**: `cob-test-amq-vpc-ca-tor-1`
    * Subnets:
      * `cob-test-vpc-ca-tor-subnet-01-ca-tor-1`
      * `cob-test-vpc-ca-tor-subnet-02-ca-tor-2`
      * `cob-test-vpc-ca-tor-subnet-03-ca-tor-3`
    * Security groups named:
      * `cob-test-vpc-ca-tor-sec-grp-01`
        * This security group adds an inbound rule for ssh and ping
      * `cob-test-vpc-ca-tor-sec-grp-02`
        * This security group adds inbound rules to allow access to following ports:
          * `5672`  - AMQP broker amqp accepts connection on this port
          * `8161`  - AMQ console listens on this port
          * `61616` - AMQ broker artemis accepts connection on this port
      * `cob-test-vpc-ca-tor-sec-grp-03`
        * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
    * VSIs (Virtual Server Instance):
      * NFS server: `cob-test-ca-tor-1-nfs-server-01`
      * Broker01: `cob-test-broker01-live1`
      * Broker02: `cob-test-broker02-bak1`
      * Broker03: `cob-test-broker03-live2`
      * Broker04: `cob-test-broker04-bak2`
      * Router01 (hub): `cob-test-hub-router1`
      * Router02 (spoke): `cob-test-spoke-router2`
    * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
  * **VPC**: `cob-test-amq-vpc-ca-tor-2`
    * Subnets:
      * `cob-test-vpc-ca-tor-subnet-01-ca-tor-1`
      * `cob-test-vpc-ca-tor-subnet-02-ca-tor-2`
      * `cob-test-vpc-ca-tor-subnet-03-ca-tor-3`
    * Security groups named:
      * `cob-test-vpc-ca-tor-sec-grp-01`
        * This security group adds an inbound rule for ssh and ping
      * `cob-test-vpc-ca-tor-sec-grp-02`
        * This security group adds inbound rules to allow access to following ports:
          * `5672`  - AMQP broker amqp accepts connection on this port
          * `8161`  - AMQ console listens on this port
          * `61616` - AMQ broker artemis accepts connection on this port
      * `cob-test-vpc-ca-tor-sec-grp-03`
        * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
    * VSIs (Virtual Server Instance):
      * NFS server: `cob-test-ca-tor-2-nfs-server-02`
      * Broker01: `cob-test-broker05-live3`
      * Broker02: `cob-test-broker06-bak3`
      * Broker03: `cob-test-broker07-live4`
      * Broker04: `cob-test-broker08-bak4`
      * Router03 (spoke): `cob-test-spoke-router3`
    * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
  * **Local Transit Gateway**
    * `cob-test-ca-tor-local-01`
      * Facilitates communications between Hub router (router 1) and Spoke routers (router 2 and 3).
        Spoke router (router 3) is running in a different VPC than the Hub router
    * _Purpose of the Local Transit Gateway is to allow communications between the Hub router and spoke routers, within same region_
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS servers (Region 1) - manual step
* Setup NFS servers for Cluster1 (VPC1) and Cluster2 (VPC2) by following these steps:
  * **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
  * Find the public IP for each NFS server by running following commands:
    * Cluster1 NFS server: `terraform output vpc1-nfs-server-public_ip`
    * Cluster2 NFS server: `terraform output vpc2-nfs-server-public_ip`
  * Execute following commands _for each NFS server by substituting the `NFS_IP_ADDRESS` with ip addresses from previous step_:
    ```shell
    scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files
    ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>
    chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
    chown -R nobody: /mnt/nfs_shares/amq/files  
    ```

<br>


### Setup Broker1 (Region 1) - manual step
_Broker1 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker01-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker01-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster1/broker1_live1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-01/etc`x
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster1/broker1_live1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.51:8161`

<br>


### Setup Broker2 (Region 1) - manual step
_Broker2 is Backup broker, of Broker1, running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker02-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker02-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster1/broker2_bak1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-02/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster1/broker2_bak1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.64.51:8161`

<br>


### Setup Broker3 (Region 1) - manual step
_Broker3 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker03-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker03-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster1/broker3_live2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-03/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster1/broker3_live2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.128.51:8161`

<br>


### Setup Broker4 (Region 1) - manual step
_Broker4 is Backup broker, of Broker3, running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker04-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker04-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster1/broker4_bak2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-04/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster1/broker4_bak2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.52:8161`

<br>


### Setup Broker5 (Region 1) - manual step
_Broker5 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker05-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker05-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster2/broker5_live3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-05/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster2/broker5_live3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.61:8161`

<br>


### Setup Broker6 (Region 1) - manual step

_Broker6 is Backup broker, of Broker5, running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker06-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker06-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster2/broker6_bak3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-06/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster2/broker6_bak3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.64.61:8161`

<br>


## Setup Broker7 (Region 1) - manual step
_Broker7 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker07-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker07-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster2/broker7_live4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-07/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster2/broker7_live4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.0.61:8161`
 
<br>


## Setup Broker8 (Region 1) - manual step
_Broker8 is Backup broker, of Broker7, running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker08-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker08-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region1/cluster2/broker8_bak4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-08/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region1/cluster2/broker8_bak4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.62:8161`

<br>


### Setup VPC1 hub router (Region 1) - manual step
Technically, _this router is not part of either cluster1 or cluster2_, but is part of VPC1 where cluster1 is running.
It's going to accept connections from consumers and producers as well as from spoke routers, which will connect to
Live brokers in cluster1/cluster2.
<br>

* Run `terraform output vpc1-router-01-hub-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/hub-router1/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>

### Setup VPC1 spoke router (Region 1) - manual step
This is Spoke router 02, that connects to cluster1 and sends/receives messages with broker 01/03. It also connects to the
hub router
<br>

* Run `terraform output vpc1-router-02-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/spoke-router2/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>

### Setup VPC2 spoke router (Region 1) - manual step
This is Spoke router 03, that connects to cluster2 and sends/receives messages with broker 05/06. It also connects to the
hub router that is running in VPC1 (_this will make use of the local Transit Gateway that should be setup by automated step_)
<br>

* Run `terraform output vpc2-router-03-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/spoke-router3/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>


## Setup Region 2
Region 1 is setup in **Dallas** that has two clusters:
* **Cluster1** - consisting of following four brokers:
  * `broker01` - live/primary
  * `broker02` - backup of broker01
  * `broker03` - live/primary
  * `broker04` - backup of broker03

* **Cluster2** - consisting of following four brokers:
  * `broker05` - live/primary
  * `broker06` - backup of broker05
  * `broker07` - live/primary
  * `broker08` - backup of broker07

As part of cluster1 config, following interconnect routers are also created and setup (in the same VPC):
* router01 - Hub router - accepts connections from consumers/producers
* router02 - Spoke router - connects to live brokers in Cluster1 and also to Hub router (router01)

As part of cluster2 config, following interconnect router is also created and setup (in the same VPC):
* router03 - Spoke router - connects to live brokers in Cluster2 and also to Hub router (router01) that is part of
  the config for Cluster1

#### Prerequisites - Region 2
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_
* IBM API key should have been setup as part of [setting up API key config](#setup-config-for-ibm-api-key)

<br>

### Setup Region 2 - automated step
* Perform setup of region 2 (cluster1/cluster2) by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/dallas
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform init
  terraform apply -auto-approve -var PREFIX="cob-test"
  ```
  * _All resources created will have the PREFIX provided in the last command_
* Above command will take around 4-5 minutes and should create following resources:
  * **VPC**: `cob-test-amq-vpc-us-south-1`
    * Subnets:
      * `cob-test-vpc-us-south-subnet-01-us-south-1`
      * `cob-test-vpc-us-south-subnet-02-us-south-2`
      * `cob-test-vpc-us-south-subnet-03-us-south-3`
    * Security groups named:
      * `cob-test-vpc-us-south-sec-grp-01`
        * This security group adds an inbound rule for ssh and ping
      * `cob-test-vpc-us-south-sec-grp-02`
        * This security group adds inbound rules to allow access to following ports:
          * `5672`  - AMQP broker amqp accepts connection on this port
          * `8161`  - AMQ console listens on this port
          * `61616` - AMQ broker artemis accepts connection on this port
      * `cob-test-vpc-us-south-sec-grp-03`
        * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
    * VSIs (Virtual Server Instance):
      * NFS server: `cob-test-us-south-1-nfs-server-01`
      * Broker01: `cob-test-broker01-live1`
      * Broker02: `cob-test-broker02-bak1`
      * Broker03: `cob-test-broker03-live2`
      * Broker04: `cob-test-broker04-bak2`
      * Router01 (hub): `cob-test-hub-router1`
      * Router02 (spoke): `cob-test-spoke-router2`
    * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
  * **VPC**: `cob-test-amq-vpc-us-south-2`
    * Subnets:
      * `cob-test-vpc-us-south-subnet-01-us-south-1`
      * `cob-test-vpc-us-south-subnet-02-us-south-2`
      * `cob-test-vpc-us-south-subnet-03-us-south-3`
    * Security groups named:
      * `cob-test-vpc-us-south-sec-grp-01`
        * This security group adds an inbound rule for ssh and ping
      * `cob-test-vpc-us-south-sec-grp-02`
        * This security group adds inbound rules to allow access to following ports:
          * `5672`  - AMQP broker amqp accepts connection on this port
          * `8161`  - AMQ console listens on this port
          * `61616` - AMQ broker artemis accepts connection on this port
      * `cob-test-vpc-us-south-sec-grp-03`
        * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
    * VSIs (Virtual Server Instance):
      * NFS server: `cob-test-us-south-2-nfs-server-02`
      * Broker01: `cob-test-broker05-live3`
      * Broker02: `cob-test-broker06-bak3`
      * Broker03: `cob-test-broker07-live4`
      * Broker04: `cob-test-broker08-bak4`
      * Router03 (spoke): `cob-test-spoke-router3`
    * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
  * **Local Transit Gateway**
    * `cob-test-us-south-local-01`
      * Facilitates communications between Hub router (router 1) and Spoke routers (router 2 and 3).
        Spoke router (router 3) is running in a different VPC than the Hub router
    * _Purpose of the Local Transit Gateway is to allow communications between the Hub router and spoke routers, within same region_
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS servers (Region 2) - manual step
* Setup NFS servers for Cluster1 (VPC1) and Cluster2 (VPC2) by following these steps:
  * **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
  * Find the public IP for each NFS server by running following commands:
    * Cluster1 NFS server: `terraform output vpc1-nfs-server-public_ip`
    * Cluster2 NFS server: `terraform output vpc2-nfs-server-public_ip`
  * Execute following commands _for each NFS server by substituting the `NFS_IP_ADDRESS` with ip addresses from previous step_:
    ```shell
    scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files
    ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>
    chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
    chown -R nobody: /mnt/nfs_shares/amq/files  
    ```

<br>


### Setup Broker1 (Region 2) - manual step
_Broker1 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker01-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker01-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster1/broker1_live1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-01/etc`x
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster1/broker1_live1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.51:8161`

<br>


### Setup Broker2 (Region 2) - manual step
_Broker2 is Backup broker, of Broker1, running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker02-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker02-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster1/broker2_bak1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-02/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster1/broker2_bak1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.64.51:8161`

<br>


### Setup Broker3 (Region 2) - manual step
_Broker3 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker03-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker03-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster1/broker3_live2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-03/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster1/broker3_live2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.128.51:8161`

<br>


### Setup Broker4 (Region 2) - manual step
_Broker4 is Backup broker, of Broker3, running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc1-broker04-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc1-broker04-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster1/broker4_bak2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-04/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster1/broker4_bak2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.52:8161`

<br>


### Setup Broker5 (Region 2) - manual step
_Broker5 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker05-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker05-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster2/broker5_live3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-05/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster2/broker5_live3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.61:8161`

<br>


### Setup Broker6 (Region 2) - manual step

_Broker6 is Backup broker, of Broker5, running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker06-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker06-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster2/broker6_bak3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-06/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster2/broker6_bak3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.64.61:8161`

<br>


## Setup Broker7 (Region 2) - manual step
_Broker7 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker07-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker07-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster2/broker7_live4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-07/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster2/broker7_live4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.0.61:8161`

<br>


## Setup Broker8 (Region 2) - manual step
_Broker8 is Backup broker, of Broker7, running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output vpc2-broker08-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `vpc2-broker08-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/broker/region2/cluster2/broker8_bak4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-08/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/broker/region2/cluster2/broker8_bak4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.62:8161`

<br>


### Setup VPC1 hub router (Region 2) - manual step
Technically, _this router is not part of either cluster1 or cluster2_, but is part of VPC1 where cluster1 is running.
It's going to accept connections from consumers and producers as well as from spoke routers, which will connect to
Live brokers in cluster1/cluster2.
<br>

* Run `terraform output vpc1-router-01-hub-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/hub-router1/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>

### Setup VPC1 spoke router (Region 2) - manual step
This is Spoke router 02, that connects to cluster1 and sends/receives messages with broker 01/03. It also connects to the
hub router
<br>

* Run `terraform output vpc1-router-02-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/spoke-router2/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>

### Setup VPC2 spoke router (Region 2) - manual step
This is Spoke router 03, that connects to cluster2 and sends/receives messages with broker 05/06. It also connects to the
hub router that is running in VPC1 (_this will make use of the local Transit Gateway that should be setup by automated step_)
<br>

* Run `terraform output vpc2-router-03-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/router/spoke-router3/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>



## Global Transit Gateway setup
This section contains information on setting up transit gateways for communications between:
* Cluster1 and Cluster3 - between different regions
* Cluster2 and Cluster4 - between different regions

* Perform setup of Transit Gateways by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/transit-gateway/global
  terraform init
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform apply -auto-approve -var PREFIX="cob-test"
  ```
* Above command will take around 5-7 minutes and should create following Global Transit Gateways:
  * `cob-test-amq-us-south-ca-tor-1`
    * Facilitates communications between Cluster1 (Toronto) and Cluster3 (Dallas)
    * _This gateway is located in Dallas_
  * `cob-test-amq-ca-tor-us-south-2`
    * Facilitates communications between Cluster2 (Toronto) and Cluster4 (Dallas)
    * _This gateway is located in Toronto_

<br>
<br>


## Common steps
This section contains common code

### Broker instance manual setup
This step sets up broker instance

* SSH into the broker instance by using the public IP address of broker instance
  * `ssh -i ~/.ssh/id_rsa root@<BROKER_IP_ADDRESS>`
* Perform following steps on the broker instance:
  * Run following commands
    ```shell
    chown amq_runner:amq_runner /home/amq_runner/setup.sh
    chmod +x /home/amq_runner/setup.sh
    su - amq_runner
    ./setup.sh
    ```
    * _Provide `amq_password` as the password when prompted on the execution of `setup.sh` (or any other command that requires `sudo` access)_
    * If above command fails with `unzip: command not found` error then run following command:
      * sudo dnf install -y java-11-openjdk nfs-utils zip unzip
    
### Edit broker.xml
* Edit `broker.xml` and remove following element:
  * `<acceptors>`
* Paste the contents of `config-broker_partial.xml` (_from `broker` directory that is mentioned in previous step_) in `broker.xml`.
  * _The content can be pasted at the location where above elements were deleted_

### Create jgroups-ping.xml
  * Create a new file named `jgroups-ping.xml` and paste the contents of `config-jgroups.xml` (_from
   `broker` directory that is mentioned in previous step_)

### Router instance manual setup
This step sets up router instance

* **Wait for a few minutes for the custom script (part of user_data) to execute on this router instance**
* Search following line in `$MAIN_CONFIG_DIR/router/initial_setup-02.sh`:
  * `sudo subscription-manager register --username <USERNAME> --password <PASSWORD> --auto-attach`
  * Substitute `<USERNAME>` and `<PASSWORD>` with correct username and password for RedHat login
    * _If the password contains special character or space, please enclose the password in single quotes_
* _Execute following commands (substitute the `ROUTER_IP_ADDRESS` with public ip retrieved for the router)_
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/router/initial_setup-02.sh root@<ROUTER_IP_ADDRESS>:/home/amq_runner/setup.sh`
  * SSH into the router instance by using the public IP address of router instance
    * `ssh -i ~/.ssh/id_rsa root@<ROUTER_IP_ADDRESS>`
* Perform following steps on the router instance:
  * Run following commands
    ```shell
    chown amq_runner:amq_runner /home/amq_runner/setup.sh
    chmod +x /home/amq_runner/setup.sh
    su - amq_runner
    ./setup.sh
    ```
    * _Provide `amq_password` as the password when prompted on the execution of `setup.sh`_


<hr style="height:1px"/>

<br>
<br>

## Running brokers and routers
This section provides information on how to run the complete setup - brokers and routers

### Cluster1 - Toronto region

<details>
<summary>Run brokers/routers for Cluster1</summary>

[Retrieve public IP](#retrieve-instance-public-ip---region-1) for any of the instances running in Cluster1

#### Running broker01:
To run broker01, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-01/bin/artemis run
````

#### Running broker02:
To run broker02, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-02/bin/artemis run
````

#### Running broker03:
To run broker03, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-03/bin/artemis run
````

#### Running broker04:
To run broker04, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-04/bin/artemis run
````

#### Running router01 (Hub):
To run router 01 (Hub router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

#### Running router02 (Spoke):
To run router 02 (Spoke router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

</details>

### Cluster2 - Toronto region

<details>
<summary>Run brokers/routers for Cluster2</summary>

[Retrieve public IP](#retrieve-instance-public-ip---region-1) for any of the instances running in Cluster2

#### Running broker05:
To run broker05, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-05/bin/artemis run
````

#### Running broker06:
To run broker06, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-06/bin/artemis run
````

#### Running broker07:
To run broker07, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-07/bin/artemis run
````

#### Running broker08:
To run broker08, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-08/bin/artemis run
````

#### Running router03 (Spoke):
To run router 03 (Spoke router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

</details>


### Cluster1 - Dallas region

<details>
<summary>Run brokers/routers for Cluster1</summary>

[Retrieve public IP](#retrieve-instance-public-ip---region-2) for any of the instances running in Cluster1

#### Running broker01:
To run broker01, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-01/bin/artemis run
````

#### Running broker02:
To run broker02, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-02/bin/artemis run
````

#### Running broker03:
To run broker03, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-03/bin/artemis run
````

#### Running broker04:
To run broker04, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-04/bin/artemis run
````

#### Running router01 (Hub):
To run router 01 (Hub router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

#### Running router02 (Spoke):
To run router 02 (Spoke router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

</details>

### Cluster2 - Dallas region

<details>
<summary>Run brokers/routers for Cluster2</summary>

[Retrieve public IP](#retrieve-instance-public-ip---region-2) for any of the instances running in Cluster2

#### Running broker05:
To run broker05, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-05/bin/artemis run
````

#### Running broker06:
To run broker06, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-06/bin/artemis run
````

#### Running broker07:
To run broker07, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-07/bin/artemis run
````

#### Running broker08:
To run broker08, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-08/bin/artemis run
````

#### Running router03 (Spoke):
To run router 03 (Spoke router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

</details>

<hr style="height:1px"/>

<br>
<br>

## Destroy the resources
This section provides information on how to cleanup / delete the resources that were setup for all the clusters in
the two regions

### Destroy resources - Region 1
* To delete resources setup in region 1 (cluster 1/2), use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/toronto
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```

### Destroy resources - Region 2
* To delete resources setup in region 2 (cluster 1/2), use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/dallas
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```

<hr style="height:1px"/>

<br>
<br>

## Retrieving public IP for instances

### Prerequisites
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_


### Retrieve instance public IP - Region 1
* To retrieve public IP for instances running as part of Region 1 setup, run following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/toronto
    terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name                     |
    | -------- | ------- | ------------------- |  ------------------------------- |
    | Cluster1 | Toronto | `broker-01`         | `vpc1-broker01-live-public_ip`   |
    |          |         | `broker-02`         | `vpc1-broker02-bak-public_ip`    |
    |          |         | `broker-03`         | `vpc1-broker03-live-public_ip`   |
    |          |         | `broker-04`         | `vpc1-broker04-bak-public_ip`    |
    |          |         | `nfs-server`        | `vpc1-nfs-server-public_ip`      |
    |          |         | `router-01` (hub)   | `vpc1-router-01-hub-public_ip`   |
    |          |         | `router-02` (spoke) | `vpc1-router-02-spoke-public_ip` |
    | Cluster2 | Toronto | `broker-05`         | `vpc2-broker05-live-public_ip`   |
    |          |         | `broker-06`         | `vpc2-broker06-bak-public_ip`    |
    |          |         | `broker-07`         | `vpc2-broker07-live-public_ip`   |
    |          |         | `broker-08`         | `vpc2-broker08-bak-public_ip`    |
    |          |         | `nfs-server`        | `vpc2-nfs-server-public_ip`      |
    |          |         | `router-03` (spoke) | `vpc2-router-03-spoke-public_ip` |


### Retrieve instance public IP - Region 2
* To retrieve public IP for instances running as part of Region 2 setup, run following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/dallas
    terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name                     |
    | -------- | ------- | ------------------- |  ------------------------------- |
    | Cluster1 | Toronto | `broker-01`         | `vpc1-broker01-live-public_ip`   |
    |          |         | `broker-02`         | `vpc1-broker02-bak-public_ip`    |
    |          |         | `broker-03`         | `vpc1-broker03-live-public_ip`   |
    |          |         | `broker-04`         | `vpc1-broker04-bak-public_ip`    |
    |          |         | `nfs-server`        | `vpc1-nfs-server-public_ip`      |
    |          |         | `router-01` (hub)   | `vpc1-router-01-hub-public_ip`   |
    |          |         | `router-02` (spoke) | `vpc1-router-02-spoke-public_ip` |
    | Cluster2 | Toronto | `broker-05`         | `vpc2-broker05-live-public_ip`   |
    |          |         | `broker-06`         | `vpc2-broker06-bak-public_ip`    |
    |          |         | `broker-07`         | `vpc2-broker07-live-public_ip`   |
    |          |         | `broker-08`         | `vpc2-broker08-bak-public_ip`    |
    |          |         | `nfs-server`        | `vpc2-nfs-server-public_ip`      |
    |          |         | `router-03` (spoke) | `vpc2-router-03-spoke-public_ip` |
  
<br>
<br>

## Instance info
This section provides region / zone / private IP address for each of the instance setup in this project
<br>

| Region  | Cluster  | VPC info                      | Instance info | Private IP       | Zone info  | Description |
| ------- | -------- | ----------------------------- | ------------- | ---------------- | ---------- | ----------- |
| Toronto | Cluster1 | `cob-test-amq-vpc-ca-tor-1`   | NFS           | `10.110.0.50`    | ca-tor-1   | NFS server in Toronto zone 1 |
|         |          |                               | Broker-01     | `10.110.0.51`    | ca-tor-1   | Live1 broker in Toronto zone 1 |
|         |          |                               | Broker-02     | `10.110.64.51`   | ca-tor-2   | Backup1 (of Broker 01) broker in Toronto zone 2 |
|         |          |                               | Broker-03     | `10.110.128.51`  | ca-tor-3   | Live2 broker in Toronto zone 3 |
|         |          |                               | Broker-04     | `10.110.0.52`    | ca-tor-1   | Backup2 (backup of Broker 03) broker in Toronto zone 1 |
|         |          |                               | Router-01     | `10.110.128.100` | ca-tor-3   | Hub router in Toronto zone 3 |
|         |          |                               | Router-02     | `10.110.64.100`  | ca-tor-2   | Spoke router in Toronto zone 2 - connecting to Cluster1 |
|         | Cluster2 | `cob-test-amq-vpc-ca-tor-2`   | NFS           | `10.111.0.50`    | ca-tor-1   | NFS server in Toronto zone 1 |
|         |          |                               | Broker-05     | `10.111.128.61`  | ca-tor-3   | Live3 broker in Toronto zone 3 |
|         |          |                               | Broker-06     | `10.111.64.61`   | ca-tor-2   | Backup3 (of Broker 05) broker in Toronto zone 2 |
|         |          |                               | Broker-07     | `10.111.0.61`    | ca-tor-1   | Live4 broker in Toronto zone 1 |
|         |          |                               | Broker-08     | `10.111.128.62`  | ca-tor-3   | Backup4 (backup of Broker 07) broker in Toronto zone 1 |
|         |          |                               | Router-03     | `10.111.0.100`   | ca-tor-1   | Spoke router in Toronto zone 1 - connecting to Cluster2 |
| Dallas  | Cluster1 | `cob-test-amq-vpc-us-south-1` | NFS           | `10.200.0.50`    | us-south-1 | NFS server in Dallas zone 1 |
|         |          |                               | Broker-01     | `10.200.0.51`    | us-south-1 | Live5 broker in Dallas zone 1 |
|         |          |                               | Broker-02     | `10.200.64.51`   | us-south-2 | Backup5 broker (backup of Broker 09) in Dallas zone 2 |
|         |          |                               | Broker-03     | `10.200.128.51`  | us-south-3 | Live5 broker in Dallas zone 3 |
|         |          |                               | Broker-04     | `10.200.0.52`    | us-south-1 | Backup6 broker (backup of Broker 11) in Dallas zone 1 |
|         |          |                               | Router-01     | `10.200.128.100` | us-south-3 | Hub router in Dallas zone 3 |
|         |          |                               | Router-02     | `10.200.64.100`  | us-south-2 | Spoke router in Dallas zone 2 - connecting to Cluster1 |
|         | Cluster4 | `cob-test-amq-vpc-us-south-2` | NFS           | `10.210.64.60`   | us-south-1 | NFS server in Dallas zone 2 |
|         |          |                               | Broker-05     | `10.210.128.61`  | us-south-1 | Live7 broker in Dallas zone 3 |
|         |          |                               | Broker-06     | `10.210.0.61`    | us-south-2 | Backup7 broker (backup of Broker 13) in Dallas zone 1 |
|         |          |                               | Broker-07     | `10.210.64.61`   | us-south-3 | Live8 broker in Dallas zone 2 |
|         |          |                               | Broker-08     | `10.210.0.62`    | us-south-1 | Backup8 broker (backup of Broker 15) in Dallas zone 1 |
|         |          |                               | Router-03     | `10.210.0.100`   | us-south-2 | Spoke router in Dallas zone 1 - connecting to Cluster4 |



## References
* [Hub and spoke router topology setup](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/manualconfig/routertopology/fanout)
* [AMQ Interconnect Router - Hub and Spoke network](https://access.redhat.com/documentation/en-us/red_hat_amq/7.4/html-single/using_amq_interconnect/index#connecting-routers-router)
* [Terraform config location](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/automation)

