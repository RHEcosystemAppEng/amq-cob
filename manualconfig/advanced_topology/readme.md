
# Configuring AMQ DR advanced topology 

* [Prerequisites](#prerequisites)
  * [Install Terraform](#install-terraform)
  * [Verify installation](#verify-installation)
  * [Download AMQ archive](#download-rhamq-archive-file)
  * [Checkout config](#checkout-setup-config)
  * [Create API key](#create-api-key-for-ibm-cloud)
  * [Create SSH key](#create-ssh-key-to-work-with-vpc)

<details>
<summary>Toronto - Cluster 1</summary>

  * [Setup Region 1 / Cluster 1](#setup-region-1---cluster1)
    * [Setup API key config](#setup-config-for-ibm-api-key)
    * [Setup Cluster 1 - automated step](#setup-cluster-1---automated-step)
    * Manual Steps
      * [Setup NFS](#setup-nfs---cluster-1---manual-step)
      * Brokers
        * [Setup Broker1](#setup-broker1---manual-step)
        * [Setup Broker2 - Backup of Broker 1](#setup-broker2-backup-of-broker-1---manual-step)
        * [Setup Broker3](#setup-broker3---manual-step)
        * [Setup Broker4 - Backup of Broker 3](#setup-broker4-backup-of-broker-3---manual-step)
      * Routers
        * [Setup hub router](#setup-hub-router-router-1---manual-step)
        * [Setup spoke router](#setup-spoke-router-router-2---manual-step)

</details>

<details>
<summary>Toronto - Cluster 2</summary>

  * [Setup Region 1 / Cluster 2](#setup-region-1---cluster2)
    * [Prerequisites](#prerequisites---cluster-2)
    * [Setup Cluster 2 - automated step](#setup-cluster-2---automated-step)
    * Manual Steps
      * [Setup NFS](#setup-nfs---cluster-2---manual-step)
      * Brokers
        * [Setup Broker5](#setup-broker5---manual-step)
        * [Setup Broker6 - Backup of Broker 5](#setup-broker6-backup-of-broker-5---manual-step)
        * [Setup Broker7](#setup-broker7---manual-step)
        * [Setup Broker8 - Backup of Broker 7](#setup-broker8-backup-of-broker-7---manual-step)
      * Routers
        * [Setup spoke router](#setup-spoke-router-router-3---manual-step)

</details>

<details>
<summary>Dallas - Cluster 3</summary>

  * [Setup Region 2 / Cluster 3](#setup-region-2---cluster3)
    * [Prerequisites](#prerequisites---cluster-3)
    * [Setup Cluster 3 - automated step](#setup-cluster-3---automated-step)
    * Manual Steps
      * [Setup NFS](#setup-nfs---cluster-3---manual-step)
      * Brokers
        * [Setup Broker9](#setup-broker9---manual-step)
        * [Setup Broker10 - Backup of Broker 9](#setup-broker10-backup-of-broker-9---manual-step)
        * [Setup Broker11](#setup-broker11---manual-step)
        * [Setup Broker12 - Backup of Broker 11](#setup-broker12-backup-of-broker-11---manual-step)
      * Routers
        * [Setup hub router](#setup-hub-router-router-4---manual-step)
        * [Setup spoke router](#setup-spoke-router-router-5---manual-step)

</details>

<details>
<summary>Dallas - Cluster 4</summary>

  * [Setup Region 2 / Cluster 3](#setup-region-2---cluster3)
    * [Prerequisites](#prerequisites---cluster-4)
    * [Setup Cluster - automated step](#main-setup---cluster-4)
    * Manual Steps
      * [Setup NFS](#setup-nfs---cluster-4---manual-step)
      * Brokers
        * [Setup Broker13](#setup-broker13---manual-step)
        * [Setup Broker14 - Backup of Broker 13](#setup-broker14-backup-of-broker-13---manual-step)
        * [Setup Broker15](#setup-broker15---manual-step)
        * [Setup Broker16 - Backup of Broker 15](#setup-broker16-backup-of-broker-15---manual-step)
      * Routers
        * [Setup spoke router](#setup-spoke-router-router-6---manual-step)

</details>

* [Transit Gateway setup](#transit-gateway-setup)


<details>
<summary>Run the setup</summary>

  * [Run brokers/routers](#running-brokers-and-routers)
    * [Cluster1](#cluster1---toronto-region)
    * [Cluster2](#cluster2---toronto-region)
    * [Cluster3](#cluster3---dallas-region)
    * [Cluster4](#cluster4---dallas-region)

</details>

<details>
<summary>Delete the setup</summary>

  * [Destroy the resources](#destroy-the-resources)
    * [Cluster1](#destroy-resources---cluster-1)
    * [Cluster2](#destroy-resources---cluster-2)
    * [Cluster3](#destroy-resources---cluster-3)
    * [Cluster4](#destroy-resources---cluster-4)

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
    * Hub and other routers are part of hub and spoke (or fan-out) topology
  * Two sets of Live/Backup brokers running in different availability zones (AZs) in each cluster
* Region 2 (Dallas)
  * Two clusters
  * Hub Router
  * Routers to connect to live brokers in each clusters
    * Hub and other routers are part of fan-out (or hub and spoke) topology
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


## Setup Region 1 - Cluster1
Region 1 is setup in **Toronto**. Cluster1 consists of following four brokers:
* broker01 - live/primary
* broker02 - backup of broker01
* broker03 - live/primary
* broker04 - backup of broker03

As part of cluster1 config, following interconnect routers are also created and setup (in the same VPC):
* router01 - Hub router - accepts connections from consumers/producers
* router02 - Spoke router - connects to live brokers in Cluster1 and also to Hub router (router01)

_`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

<br>

### Setup config for IBM API key
* Create a file named `terraform.tfvars`, _in `$MAIN_CONFIG_DIR/files` directory_, with following content:
  ```shell
  ibmcloud_api_key = "<YOUR_IBM_CLOUD_API_KEY>"
  ssh_key = "<NAME_OF_YOUR_SSH_KEY>"
  ```
  _Substitute with your actual IBM Cloud API key here_

<br>

### Setup Cluster 1 - automated step
* Perform setup of cluster 1 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/toronto
  terraform init
  cd cluster1
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform init
  terraform apply -auto-approve
  ```
* Above command will take around 2-3 minutes and should create following resources:
  * VPC: `appeng-100-amq-vpc-ca-tor-1`
  * Subnets:
    * `appeng-100-amq-subnet-ca-tor-1-01`
    * `appeng-100-amq-subnet-ca-tor-2-01`
    * `appeng-100-amq-subnet-ca-tor-3-01`
  * Security groups named:
    * `appeng-100-amq-sec-grp-01`
      * This security group adds an inbound rule for ssh and ping
    * `appeng-100-amq-sec-grp-02`
      * This security group adds inbound rules to allow access to following ports:
        * `5672`  - AMQP broker amqp accepts connection on this port
        * `8161`  - AMQ console listens on this port
        * `61616` - AMQ broker artemis accepts connection on this port
    * `appeng-100-amq-sec-grp-03`
      * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
  * VSIs (Virtual Server Instance):
    * NFS server: `appeng-100-ca-tor-1-nfs-server-01`
    * Broker01: `appeng-100-broker01-live1`
    * Broker02: `appeng-100-broker02-bak1`
    * Broker03: `appeng-100-broker03-live2`
    * Broker04: `appeng-100-broker04-bak2`
    * Router01 (hub): `appeng-100-hub-router1`
    * Router02 (spoke): `appeng-100-spoke-router2`
  * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS - Cluster 1 - manual step
* Setup NFS by running following commands
* Above command will create following resources:
* Run `terraform output nfs-server-public_ip` and use this ip address in next commands
* **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
* Execute following command (_substitute the `NFS_IP_ADDRESS` with `nfs-server-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files`
* SSH into the NFS instance by using the public IP address of NFS instance
  * `ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>`
* Run following commands
  ```shell
  chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
  chown -R nobody: /mnt/nfs_shares/amq/files
  ```

<br>

### Setup Broker1 - manual step
_Broker1 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker01-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker01-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster1/broker1_live1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-01/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster1/broker1_live1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.51:8161`

<br>

### Setup Broker2 (backup of broker 1) - manual step
_Broker2 is Backup broker running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker02-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker02-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster1/broker2_bak1/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-02/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster1/broker2_bak1`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.64.51:8161`

<br>

### Setup Broker3 - manual step
_Broker3 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker03-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker03-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster1/broker3_live2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-03/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster1/broker3_live2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.128.51:8161`

<br>

### Setup Broker4 (backup of broker 3) - manual step
_Broker4 is Backup broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker04-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker04-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster1/broker4_bak2/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-04/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster1/broker4_bak2`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.110.0.52:8161`

<br>

### Setup hub router (router 1) - manual step
Technically, _this router is not part of either cluster1 or cluster2_, but is part of same VPC as cluster1.
It's going to accept connections from consumers and producers as well as from spoke routers, which will connect to
Live brokers in cluster1/cluster2.
<br>

* Run `terraform output router-01-hub-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/toronto/router/hub-router1/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>

### Setup spoke router (router 2) - manual step
This router will connect to cluster1 and will send/receive messages with broker 01/03. It will also connect to the
hub router
<br>

* Run `terraform output router-02-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/toronto/router/spoke-router2/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>


## Setup Region 1 - Cluster2
Region 1 is setup in **Toronto**. Cluster2 consists of following four brokers:
* broker05 - live/primary
* broker06 - backup of broker05
* broker07 - live/primary
* broker08 - backup of broker07

As part of cluster2 config, following interconnect router is also created and setup (in the same VPC):
* router03 - Spoke router - connects to live brokers in Cluster2 and also to Hub router (router01) that is part of
  the config for Cluster1

### Prerequisites - Cluster 2
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_
* IBM API key should have been setup as part of [setting up API key config](#setup-config-for-ibm-api-key)


<br>


### Setup Cluster 2 - automated step
* Perform setup of cluster 2 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/toronto/cluster2
  terraform init
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform apply -auto-approve
  ```
* Above command will take around 2-3 minutes and should create following resources:
  * VPC: `appeng-100-amq-vpc-ca-tor-2`
  * Subnets:
    * `appeng-100-amq-subnet-ca-tor-1-02`
    * `appeng-100-amq-subnet-ca-tor-2-02`
    * `appeng-100-amq-subnet-ca-tor-3-02`
  * Security groups named:
    * `appeng-100-amq-sec-grp-04`
      * This security group adds an inbound rule for ssh and ping
    * `appeng-100-amq-sec-grp-05`
      * This security group adds inbound rules to allow access to following ports:
        * `5672`  - AMQP broker amqp accepts connection on this port
        * `8161`  - AMQ console listens on this port
        * `61616` - AMQ broker artemis accepts connection on this port
    * `appeng-100-amq-sec-grp-06`
      * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
  * VSIs (Virtual Server Instance):
    * NFS server: `appeng-100-ca-tor-2-nfs-server-01`
    * Broker01: `appeng-100-broker05-live3`
    * Broker02: `appeng-100-broker06-bak3`
    * Broker03: `appeng-100-broker07-live4`
    * Broker04: `appeng-100-broker08-bak4`
    * Router03 (spoke): `appeng-100-spoke-router3`
  * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS - Cluster 2 - manual step
* Setup NFS by running following commands
* Above command will create following resources:
* Run `terraform output nfs-server-public_ip` and use this ip address in next commands
* **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
* Execute following command (_substitute the `NFS_IP_ADDRESS` with `nfs-server-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files`
* SSH into the NFS instance by using the public IP address of NFS instance
  * `ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>`
* Run following commands
  ```shell
  chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
  chown -R nobody: /mnt/nfs_shares/amq/files
  ```

<br>

### Setup Broker5 - manual step
_Broker5 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker05-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker05-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster2/broker5_live3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-05/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster2/broker5_live3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.61:8161`

<br>

### Setup Broker6 (backup of broker 5) - manual step
_Broker6 is Backup broker running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker06-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker06-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster2/broker6_bak3/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-06/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster2/broker6_bak3`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.64.61:8161`

<br>

### Setup Broker7 - manual step
_Broker7 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker07-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker07-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster2/broker7_live4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-07/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster2/broker7_live4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.0.61:8161`

<br>

### Setup Broker8 (backup of broker 7) - manual step
_Broker8 is Backup broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker08-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker08-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/broker/cluster2/broker8_bak4/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-08/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/toronto/broker/cluster2/broker8_bak4`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.111.128.62:8161`

<br>

### Setup spoke router (router 3) - manual step
This router will connect to cluster2 and will send/receive messages with broker 05/07. It will also connect to the
hub router that is setup as part of Cluster1 config.
<br>

* Run `terraform output router-03-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/toronto/router/spoke-router3/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>

## Setup Region 2 - Cluster3
Region 2 is setup in **Dallas**. Cluster3 consists of following four brokers:
* broker09 - live/primary
* broker10 - backup of broker09
* broker11 - live/primary
* broker12 - backup of broker11

As part of cluster3 config, following interconnect routers are also created and setup (in the same VPC):
* router04 - Hub router - accepts connections from consumers/producers
* router05 - Spoke router - connects to live brokers in Cluster3 and also to Hub router (router04)

### Prerequisites - Cluster 3
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_
* IBM API key should have been setup as part of [setting up API key config](#setup-config-for-ibm-api-key)

<br>


### Setup Cluster 3 - automated step
* Perform setup of cluster 3 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/dallas
  terraform init
  cd cluster3
  terraform init
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform apply -auto-approve
  ```
* Above command will take around 2-3 minutes and should create following resources:
  * VPC: `appeng-100-amq-vpc-us-south-1`
  * Subnets:
    * `appeng-100-amq-subnet-us-south-1-01`
    * `appeng-100-amq-subnet-us-south-2-01`
    * `appeng-100-amq-subnet-us-south-3-01`
  * Security groups named:
    * `appeng-100-amq-sec-grp-01`
      * This security group adds an inbound rule for ssh and ping
    * `appeng-100-amq-sec-grp-02`
      * This security group adds inbound rules to allow access to following ports:
        * `5672`  - AMQP broker amqp accepts connection on this port
        * `8161`  - AMQ console listens on this port
        * `61616` - AMQ broker artemis accepts connection on this port
    * `appeng-100-amq-sec-grp-03`
      * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
  * VSIs (Virtual Server Instance):
    * NFS server: `appeng-100-us-south-1-nfs-server-01`
    * broker09: `appeng-100-broker09-live5`
    * broker10: `appeng-100-broker10-bak5`
    * broker11: `appeng-100-broker11-live6`
    * broker12: `appeng-100-broker12-bak6`
    * Router04 (hub): `appeng-100-hub-router2`
    * Router05 (spoke): `appeng-100-spoke-router4`
  * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS - Cluster 3 - manual step
* Setup NFS by running following commands
* Above command will create following resources:
* Run `terraform output nfs-server-public_ip` and use this ip address in next commands
* **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
* Execute following command (_substitute the `NFS_IP_ADDRESS` with `nfs-server-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files`
* SSH into the NFS instance by using the public IP address of NFS instance
  * `ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>`
* Run following commands
  ```shell
  chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
  chown -R nobody: /mnt/nfs_shares/amq/files
  ```

<br>

### Setup Broker9 - manual step
_Broker9 is Live (Primary) broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker09-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker09-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster3/broker9_live5/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-09/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster3/broker9_live5`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.200.0.51:8161`

<br>

### Setup Broker10 (backup of broker 9) - manual step
_Broker10 is Backup broker running in Zone2_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker10-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker10-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster3/broker10_bak5/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-10/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster3/broker10_bak5`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.200.64.51:8161`

<br>

### Setup Broker11 - manual step
_Broker11 is Live (Primary) broker running in Zone3_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker11-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker11-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster3/broker11_live6/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-11/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster3/broker11_live6`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.200.128.51:8161`

<br>

### Setup Broker12 (backup of broker 11) - manual step
_Broker12 is Backup broker running in Zone1_
<br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker12-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker12-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster3/broker12_bak6/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-12/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster3/broker12_bak6`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.200.0.52:8161`

<br>

### Setup hub router (router 4) - manual step
Technically, _this router is not part of either cluster3 or cluster4_, but is part of same VPC as cluster3.
It's going to accept connections from consumers and producers as well as from spoke routers, which will connect to
Live brokers in cluster3/cluster4.
<br>

* Run `terraform output router-04-hub-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/dallas/router/hub-router4/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>

### Setup spoke router (router 5) - manual step
This router will connect to cluster3 and will send/receive messages with broker 09/11. It will also connect to the
hub router
<br>

* Run `terraform output router-05-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/dallas/router/spoke-router5/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>


## Setup Region 2 - Cluster4
Region 2 is setup in **Dallas**. Cluster4 consists of following four brokers:
* broker13 - live/primary
* broker14 - backup of broker13
* broker15 - live/primary
* broker16 - backup of broker15

As part of cluster4 config, following interconnect routers are also created and setup:
* router06 - Spoke router - connects to live brokers in Cluster4 and also to Hub router (router04) that is part of
  the config for Cluster3

### Prerequisites - Cluster 4
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_
* IBM API key should have been setup as part of [setting up API key config](#setup-config-for-ibm-api-key)

<br>


### Main Setup - Cluster 4
* Perform setup of Cluster 4 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/dallas/cluster4
  terraform init
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform apply -auto-approve
  ```
* Above command will take around 2-3 minutes and should create following resources:
  * VPC: `appeng-100-amq-vpc-us-south-2`
  * Subnets:
    * `appeng-100-amq-subnet-us-south-1-02`
    * `appeng-100-amq-subnet-us-south-2-02`
    * `appeng-100-amq-subnet-us-south-3-02`
  * Security groups named:
    * `appeng-100-amq-sec-grp-04`
      * This security group adds an inbound rule for ssh and ping
    * `appeng-100-amq-sec-grp-05`
      * This security group adds inbound rules to allow access to following ports:
        * 5672  - AMQP broker amqp accepts connection on this port
        * 8161  - AMQ console listens on this port
        * 61616 - AMQ broker artemis accepts connection on this port
    * `appeng-100-amq-sec-grp-06`
      * Adds an inbound rule on port 5773 that will be used by the Hub router to listen for incoming connections
  * VSIs (Virtual Server Instance):
    * NFS server: `appeng-100-us-south-2-nfs-server-02`
    * broker13: `appeng-100-broker13-live7`
    * broker14: `appeng-100-broker14-bak7`
    * broker15: `appeng-100-broker15-live8`
    * broker16: `appeng-100-broker16-bak8`
    * Router06 (spoke): `appeng-100-spoke-router5`
  * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)
* _Setting up of a NFS server/brokers/routers involves an automated as well as some manual steps. Automated part is
  already performed by the Terraform config scripts executed in above step. Manual setup will still need to be performed_


<br>

### Setup NFS - Cluster 4 - manual step
* Setup NFS by running following commands
* Above command will create following resources:
* Run `terraform output nfs-server-public_ip` and use this ip address in next commands
* **Wait for a few minutes for the custom script (part of user_data) to execute on the NFS instance**
* Execute following command (_substitute the `NFS_IP_ADDRESS` with `nfs-server-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/files/amq-broker-7.9.0-bin.zip root@<NFS_IP_ADDRESS>:/mnt/nfs_shares/amq/files`
* SSH into the NFS instance by using the public IP address of NFS instance
  * `ssh -i ~/.ssh/id_rsa root@<NFS_IP_ADDRESS>`
* Run following commands
  ```shell
  chmod 644 /mnt/nfs_shares/amq/files/amq-broker-7.9.0-bin.zip
  chown -R nobody: /mnt/nfs_shares/amq/files
  ```

<br>

### Setup Broker13 - manual step
_Broker13 is Live (Primary) broker running in Zone1_
<br><br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker13-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker13-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster4/broker13_live7/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-13/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster4/broker13_live7`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.210.128.61:8161`

<br>

### Setup Broker14 (backup of broker 13) - manual step
_Broker14 is Backup broker running in Zone2_
<br><br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker14-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker14-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster4/broker14_bak7/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-14/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster4/broker14_bak7`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.210.0.61:8161`

<br>

### Setup Broker15 - manual step
_Broker15 is Live (Primary) broker running in Zone3_
<br><br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker15-live-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker15-live-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster4/broker15_live8/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-15/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster4/broker15_live8`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.210.64.61:8161`

<br>

### Setup Broker16 (backup of broker 15) - manual step
_Broker16 is Backup broker running in Zone1_
<br><br>

* **Wait for a few minutes for the custom script (part of user_data) to execute on this broker instance**
* Run `terraform output broker16-bak-public_ip` and use this ip address in subsequent commands
* Execute following commands (_substitute the `BROKER_IP_ADDRESS` with value of `broker16-bak-public_ip` from previous step_):
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/dallas/broker/cluster4/broker16_bak8/initial_setup-02_install_amq.sh root@<BROKER_IP_ADDRESS>:/home/amq_runner/setup.sh`
* For following steps, use **public IP address retrieved above**
  * Perform steps given at [Broker instance manual setup](#broker-instance-manual-setup) to setup broker instance.
  * Perform following steps on the broker instance:
    * `cd /var/opt/amq-broker/broker-16/etc`
    * For following steps, use files from **`$MAIN_CONFIG_DIR/dallas/broker/cluster4/broker16_bak8`** directory
      * Follow the steps given at [Edit broker](#edit-brokerxml) to modify `broker.xml`
      * Execute the step given at [Create jgroups file](#create-jgroups-pingxml)
    * Edit bootstrap.xml:
      * Change `http://localhost:8161` to `http://10.210.0.62:8161`

<br>

### Setup spoke router (router 6) - manual step
This router will connect to cluster4 and will send/receive messages with broker 13/15. It will also connect to the
hub router
<br><br>

* Run `terraform output router-06-spoke-public_ip` and use this ip address in subsequent commands
* Perform steps given at [Router manual setup](#router-instance-manual-setup) to setup router instance
* Perform following steps on the broker instance (as `amq_runner` user):
  * `sudo vi /etc/qpid-dispatch/qdrouterd.conf`
    * Remove `router` element
    * Append contents of `$MAIN_CONFIG_DIR/dallas/router/spoke-router6/config-router-partial.conf` at the end of `qdrouterd.conf` file

<br>
<br>


## Transit Gateway setup
This section contains information on setting up transit gateways for communications between:
* Hub router and spoke routers - within same region
* Cluster1 and Cluster3 - between different regions
* Cluster2 and Cluster4 - between different regions

* Perform setup of Transit Gateways by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/transit-gateway
  terraform init
  cp $MAIN_CONFIG_DIR/files/terraform.tfvars .
  terraform apply -auto-approve
  ```
* Above command will take around 2-3 minutes and should create following resources:
  * _Local Transit Gateways_
    * `appeng-100-amq-ca-tor-local-01`
      * Facilitates communications between Hub router (router 1) and Spoke routers (router 2 and 3).
        Spoke router (router 3) is running in a different VPC than the Hub router
    * `appeng-100-amq-us-south-local-01`
      * Facilitates communications between Hub router (router 4) and Spoke routers (router 5 and 6).
        Spoke router (router 6) is running in a different VPC than the Hub router
  * _Global Transit Gateways_
    * `appeng-100-amq-us-south-ca-tor-1`
      * Facilitates communications between Cluster1 (Toronto) and Cluster3 (Dallas)
      * _This gateway is located in Dallas_
    * `appeng-100-amq-ca-tor-us-south-2`
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
    * _Provide `amq_password` as the password when prompted on the execution of `setup.sh`_
    
### Edit broker.xml
* Edit `broker.xml` and remove following elements:
  * `<connectors>`
  * `<acceptors>`
  * `<cluster-user>`
  * `<cluster-password>`
  * `<broadcast-groups>`
  * `<discovery-groups>`
  * `<cluster-connections>`
* Paste the contents of `config-broker_partial.xml` (_from `broker` directory that is mentioned in previous step_) in `broker.xml`.
  * _The content can be pasted at the location where above elements were deleted_

### Create jgroups-ping.xml
  * Create a new file named `jgroups-ping.xml` and paste the contents of `config-jgroups.xml` (_from
   `broker` directory that is mentioned in previous step_)

### Router instance manual setup
This step sets up router instance

* **Wait for a few minutes for the custom script (part of user_data) to execute on this router instance**
* Search following line in `$MAIN_CONFIG_DIR/toronto/router/initial_setup-02.sh`:
  * `sudo subscription-manager register --username <USERNAME> --password <PASSWORD> --auto-attach`
  * Substitute `<USERNAME>` and `<PASSWORD>` with correct username and password for RedHat login
    * _If the password contains special character or space, please enclose the password in single quotes_
* _Execute following commands (substitute the `ROUTER_IP_ADDRESS` with public ip retrieved for the router)_
  * `scp -i ~/.ssh/id_rsa $MAIN_CONFIG_DIR/toronto/router/initial_setup-02.sh root@<ROUTER_IP_ADDRESS>:/home/amq_runner/setup.sh`
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

[Retrieve public IP](#retrieve-instance-public-ip---cluster1) for any of the instances running in Cluster1

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

[Retrieve public IP](#retrieve-instance-public-ip---cluster2) for any of the instances running in Cluster2

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


### Cluster3 - Dallas region

<details>
<summary>Run brokers/routers for Cluster3</summary>

[Retrieve public IP](#retrieve-instance-public-ip---cluster3) for any of the instances running in Cluster3

#### Running broker09:
To run broker09, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-09/bin/artemis run
````

#### Running broker10:
To run broker10, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-10/bin/artemis run
````

#### Running broker11:
To run broker11, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-11/bin/artemis run
````

#### Running broker12:
To run broker12, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-12/bin/artemis run
````

#### Running router04 (Hub):
To run router 04 (Hub router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

#### Running router05 (Spoke):
To run router 05 (Spoke router), please follow the steps given below:
```shell
ssh root@<ROUTER_IP_ADDRESS>
su - amq_runner
qdrouterd
```

</details>


### Cluster4 - Dallas region

<details>
<summary>Run brokers/routers for Cluster4</summary>

[Retrieve public IP](#retrieve-instance-public-ip---cluster4) for any of the instances running in Cluster4

#### Running broker13:
To run broker13, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-13/bin/artemis run
````

#### Running broker14:
To run broker14, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-14/bin/artemis run
````

#### Running broker15:
To run broker15, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-15/bin/artemis run
````

#### Running broker16:
To run broker16, please follow the steps given below:

```shell
ssh root@<BROKER_IP_ADDRESS>
su - amq_runner
/var/opt/amq-broker/broker-16/bin/artemis run
````

#### Running router06 (Spoke):
To run router 06 (Spoke router), please follow the steps given below:
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

### Destroy resources - cluster 1
* To delete resources setup in cluster1, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/toronto/cluster1
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```

### Destroy resources - cluster 2
* To delete resources setup in cluster2, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/toronto/cluster2
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```

### Destroy resources - cluster 3
* To delete resources setup in cluster3, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/dallas/cluster3
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```

### Destroy resources - cluster 4
* To delete resources setup in cluster4, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/dallas/cluster4
    terraform plan -destroy -out=destroy.plan
    terraform apply destroy.plan
  ```


<hr style="height:1px"/>

<br>
<br>

## Retrieving public IP for instances

### Prerequisites
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_


### Retrieve instance public IP - cluster1
* To retrieve public IP for instances running as part of Cluster1 setup, run following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/toronto/cluster1
    terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name              |
    | -------- | ------- | ------------------- |  ------------------------ |
    | Cluster1 | Toronto | `broker-01`         | `broker01-live-public_ip` |
    |          |         | `broker-02`         | `broker02-bak-public_ip`  |
    |          |         | `broker-03`         | `broker03-live-public_ip` |
    |          |         | `broker-04`         | `broker04-bak-public_ip`  |
    |          |         | `nfs-server`        | `nfs-server-public_ip`    |
    |          |         | `router-01` (hub)   | `router-01-hub-public_ip` |
    |          |         | `router-02` (spoke) | `router-01-hub-public_ip` |



### Retrieve instance public IP - cluster2
* To retrieve public IP for instances running as part of Cluster2 setup, run following commands:
  ```shell
  cd $MAIN_CONFIG_DIR/toronto/cluster2
  terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name                |
    | -------- | ------- | ------------------- |  -------------------------- |
    | Cluster2 | Toronto | `broker-05`         | `broker05-live-public_ip`   |
    |          |         | `broker-06`         | `broker06-bak-public_ip`    |
    |          |         | `broker-07`         | `broker07-live-public_ip`   |
    |          |         | `broker-08`         | `broker08-bak-public_ip`    |
    |          |         | `nfs-server`        | `nfs-server-public_ip`      |
    |          |         | `router-03` (spoke) | `router-03-spoke-public_ip` |


### Retrieve instance public IP - cluster3
* To retrieve public IP for instances running as part of Cluster3 setup, run following commands:
  ```shell
  cd $MAIN_CONFIG_DIR/dallas/cluster3
  terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name                |
    | -------- | ------- | ------------------- |  -------------------------- |
    | Cluster3 | Dallas  | `broker-09`         | `broker09-live-public_ip`   |
    |          |         | `broker-10`         | `broker10-bak-public_ip`    |
    |          |         | `broker-11`         | `broker11-live-public_ip`   |
    |          |         | `broker-12`         | `broker12-bak-public_ip`    |
    |          |         | `nfs-server`        | `nfs-server-public_ip`      |
    |          |         | `router-04` (hub)   | `router-04-hub-public_ip`   |
    |          |         | `router-05` (spoke) | `router-05-spoke-public_ip` |

### Retrieve instance public IP - cluster4
* To retrieve public IP for instances running as part of Cluster4 setup, run following commands:
  ```shell
  cd $MAIN_CONFIG_DIR/dallas/cluster4
  terraform output <OUTPUT_NAME>
  ```
  * _Substitute the `<OUTPUT_NAME>` with the output name given in the table below for a given broker/router_
    
    | Cluster  | Region  | Broker/Router       |  Output Name                |
    | -------- | ------- | ------------------- |  -------------------------- |
    | Cluster4 | Dallas  | `broker-13`         | `broker13-live-public_ip`   |
    |          |         | `broker-14`         | `broker14-bak-public_ip`    |
    |          |         | `broker-15`         | `broker15-live-public_ip`   |
    |          |         | `broker-16`         | `broker16-bak-public_ip`    |
    |          |         | `nfs-server`        | `nfs-server-public_ip`      |
    |          |         | `router-06` (spoke) | `router-06-spoke-public_ip` |

<br>
<br>

## Instance info
This section provides region / zone / private IP address for each of the instance setup in this project
<br>

| Cluster  | Region  | VPC info                        | Instance info | Private IP       | Zone info  | Description |
| -------- | ------- | -----------------------------   | ------------- | ---------------- | ---------- | ----------- |
| Cluster1 | Toronto | `appeng-100-amq-vpc-ca-tor-1`   | NFS           | `10.110.0.50`    | ca-tor-1   | NFS server in Toronto zone 1 |
|          |         |                                 | Broker-01     | `10.110.0.51`    | ca-tor-1   | Live1 broker in Toronto zone 1 |
|          |         |                                 | Broker-02     | `10.110.64.51`   | ca-tor-2   | Backup1 (of Broker 01) broker in Toronto zone 2 |
|          |         |                                 | Broker-03     | `10.110.128.51`  | ca-tor-3   | Live2 broker in Toronto zone 3 |
|          |         |                                 | Broker-04     | `10.110.0.52`    | ca-tor-1   | Backup2 (backup of Broker 03) broker in Toronto zone 1 |
|          |         |                                 | Router-01     | `10.110.128.100` | ca-tor-3   | Hub router in Toronto zone 3 |
|          |         |                                 | Router-02     | `10.110.64.100`  | ca-tor-2   | Spoke router in Toronto zone 2 - connecting to Cluster1 |
| Cluster2 | Toronto | `appeng-100-amq-vpc-ca-tor-2`   | NFS           | `10.111.0.50`    | ca-tor-1   | NFS server in Toronto zone 1 |
|          |         |                                 | Broker-05     | `10.111.128.61`  | ca-tor-3   | Live3 broker in Toronto zone 3 |
|          |         |                                 | Broker-06     | `10.111.64.61`   | ca-tor-2   | Backup3 (of Broker 05) broker in Toronto zone 2 |
|          |         |                                 | Broker-07     | `10.111.0.61`    | ca-tor-1   | Live4 broker in Toronto zone 1 |
|          |         |                                 | Broker-08     | `10.111.128.62`  | ca-tor-3   | Backup4 (backup of Broker 07) broker in Toronto zone 1 |
|          |         |                                 | Router-03     | `10.111.0.100`   | ca-tor-1   | Spoke router in Toronto zone 1 - connecting to Cluster2 |
| Cluster3 | Dallas  | `appeng-100-amq-vpc-us-south-1` | NFS           | `10.200.0.50`    | us-south-1 | NFS server in Dallas zone 1 |
|          |         |                                 | Broker-09     | `10.200.0.51`    | us-south-1 | Live5 broker in Dallas zone 1 |
|          |         |                                 | Broker-10     | `10.200.64.51`   | us-south-2 | Backup5 broker (backup of Broker 09) in Dallas zone 2 |
|          |         |                                 | Broker-11     | `10.200.128.51`  | us-south-3 | Live5 broker in Dallas zone 3 |
|          |         |                                 | Broker-12     | `10.200.0.52`    | us-south-1 | Backup6 broker (backup of Broker 11) in Dallas zone 1 |
|          |         |                                 | Router-04     | `10.200.128.100` | us-south-3 | Hub router in Dallas zone 3 |
|          |         |                                 | Router-05     | `10.200.64.100`  | us-south-2 | Spoke router in Dallas zone 2 - connecting to Cluster3 |
| Cluster4 | Dallas  | `appeng-100-amq-vpc-us-south-2` | NFS           | `10.210.64.60`   | us-south-1 | NFS server in Dallas zone 2 |
|          |         |                                 | Broker-13     | `10.210.128.61`  | us-south-1 | Live7 broker in Dallas zone 3 |
|          |         |                                 | Broker-14     | `10.210.0.61`    | us-south-2 | Backup7 broker (backup of Broker 13) in Dallas zone 1 |
|          |         |                                 | Broker-15     | `10.210.64.61`   | us-south-3 | Live8 broker in Dallas zone 2 |
|          |         |                                 | Broker-16     | `10.210.0.62`    | us-south-1 | Backup8 broker (backup of Broker 15) in Dallas zone 1 |
|          |         |                                 | Router-06     | `10.210.0.100`   | us-south-2 | Spoke router in Dallas zone 1 - connecting to Cluster4 |



## References
* [Hub and spoke (Fan-out) router topology setup](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/manualconfig/routertopology/fanout)
* [AMQ Interconnect Router - Hub and Spoke network](https://access.redhat.com/documentation/en-us/red_hat_amq/7.4/html-single/using_amq_interconnect/index#connecting-routers-router)
* [Terraform config location](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/automation)

