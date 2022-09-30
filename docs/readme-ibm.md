
# Configuring AMQ DR 

* [Prerequisites](#prerequisites)
  * [Install Terraform](#install-terraform)
  * [Verify Terraform installation](#verify-terraform-installation)
  * [Install Ansible](#install-ansible)
  * [Verify Ansible installation](#verify-ansible-installation)
  * [Install Ansible collections](#install-ansible-collections)
  * [Checkout config repo](#checkout-setup-config)
  * [Download AMQ archive](#download-rhamq-archive-file)
  * [Create API key](#create-api-key-for-ibm-cloud)
  * [Create SSH key](#create-ssh-key-to-work-with-vpc)
* [Setup Region 1](#setup-region-1)
  * [Prerequisites](#prerequisites---region-1)
  * [Setup API key config](#setup-config-for-ibm-api-key)
  * [Setup Region 1 infrastructure](#setup-region-1-infrastructure)
* [Setup Region 2](#setup-region-2)
  * [Prerequisites](#prerequisites---region-2)
  * [Setup Region 2 infrastructure](#setup-region-2-infrastructure)
* [Transit Gateway setup](#global-transit-gateway-setup)
  * [Prerequisites](#prerequisites---transit-gateway-setup)
* [Configure Region 1/2 with Ansible](#configure-region-12---ansible)
  * [Prerequisites](#prerequisites---ansible-config)
  * [Capture public IP](#capture-public-ip---manual-step)
  * [Create vault password](#create-vault-password---manual-step)
  * [Configure regions](#configure-regions)
* [Run performance tests using JMeter](#run-performance-tests)
  * [Prerequisites](#prerequisites---install-jmeter)
  * [Run tests](#run-tests)
* [Other Ansible plays](#other-ansible-plays)
  * [Prerequisites](#prerequisites---other-ansible-plays)
  * [Reset regions](#reset-regions)
  * [Stop brokers and routers](#stop-brokersrouters)
  * [Run brokers and routers](#run-brokersrouters)
  * [Purge queue](#purge-queue)
* [Start/stop instances](#startstop-the-instances)
  * [Prerequisites](#prerequisites---startstop-instances)
  * [Start stopped instances](#start-instances---region-12)
  * [Stop running instances](#stop-instances---region-12)
* [Destroy the resources](#destroy-the-resources)
  * [Prerequisites](#prerequisites---destroy-resources)
  * [Global Transit Gateway](#destroy-global-transit-gateway)
  * [Region 1](#destroy-resources---region-1)
  * [Region 2](#destroy-resources---region-2)
* [Instance info](#instance-info)

<details>
<summary>TMP section for setting up cluster 1 in Toronto region</summary>

* [TMP - Setup Region 1](#setup-region-1---tmp)
  * [TMP - Prerequisites](#prerequisites---region-1---tmp)
  * [TMP - Setup API key config](#setup-config-for-ibm-api-key---tmp)
  * [TMP - Setup Region 1 infrastructure](#setup-region-1-infrastructure---tmp)
* [TMP - Configure Region 1 with Ansible](#configure-region-1---ansible---tmp)
  * [TMP - Create vault password](#create-vault-password---tmp)
  * [TMP - Configure region](#configure-region---tmp)
* [TMP - Destroy the resources](#destroy-the-resources---tmp)
  * [TMP - Region 1](#destroy-resources---region-1---tmp)

</details>

* [References](#references)

Configuring AMQ advanced topology for DR, in **IBM Cloud**, following setup was used:
* Region 1 (Toronto)
  * Two clusters
  * Hub Router
  * Routers to connect to live brokers in each clusters
    * Hub and other routers are part of hub and spoke topology
  * Two sets of Live/Backup brokers running in different availability zones (AZs) in each cluster
  * Local Transit Gateway to allow inter-VPC communication
* Region 2 (Dallas)
  * Two clusters
  * Hub Router
  * Routers to connect to live brokers in each clusters
    * Hub and other routers are part of hub and spoke topology
  * Two sets of Live/Backup brokers running in different availability zones (AZs) in each cluster
  * Local Transit Gateway to allow inter-VPC communication
* Global Transit Gateway
  * This is to allow the following inter-region communication:
    * Between region1.cluster1 and region2.cluster1 
    * Between region1.cluster2 and region2.cluster2 


## Prerequisites

### Install Terraform
Please follow instructions to [install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 
for your platform

### Verify Terraform installation
Run `terraform -help` command to verify that `terraform` is installed correctly

### Install Ansible
Please follow instructions to [install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 
for your platform

### Verify Ansible installation
Run `ansible --version` command to verify that `ansible` is installed correctly

### Install Ansible collections
Install the following Ansible collections for configuring the instances by running following commands:
  ```shell
  ansible-galaxy collection install ansible.posix community.general
  ```
* `ansible.posix` is needed for mount/unmount
* `community.general` is needed for subscription

### Checkout Setup config
Clone this repo to setup brokers/routers in IBM Cloud:
* `git clone https://github.com/RHEcosystemAppEng/amq-cob.git`
* Open up a terminal and run following commands
  ```shell
  cd amq-cob
  MAIN_CONFIG_DIR=`pwd`
  ```

### Download RHAMQ archive file
* Download RedHat AMQ by following step at [Download AMQ Broker](https://access.redhat.com/documentation/en-us/red_hat_amq/2021.q3/html/getting_started_with_amq_broker/installing-broker-getting-started#downloading-broker-archive-getting-started)
* Name the downloaded zip file `amq-broker-7.9.0-bin.zip` if it's not already named that
* Copy the downloaded AMQ archive to `$MAIN_CONFIG_DIR/ansible/roles/setup_nfs_server/files` directory

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

### Prerequisites - Region 1
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

<br>

### Setup config for IBM API key
* Create a file named `terraform.tfvars`, _in `$MAIN_CONFIG_DIR/terraform-ibm/toronto` directory_, with following content:
  ```shell
  ibmcloud_api_key = "<YOUR_IBM_CLOUD_API_KEY>"
  ssh_key = "<NAME_OF_YOUR_SSH_KEY>"
  ```
  _Substitute with your actual IBM Cloud API key here_

<br>

### Setup Region 1 infrastructure
* Terraform is used to setup the infrastructure for region1. Perform infrastructure setup of region 1
  (cluster1/cluster2) by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm/toronto
  terraform init
  terraform apply -auto-approve \
    -var PREFIX="cob-test" \
    -var CLUSTER1_PRIVATE_IP_PREFIX="10.70" \
    -var CLUSTER2_PRIVATE_IP_PREFIX="10.71"
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

### Prerequisites - Region 2
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_
* IBM API key should have been setup as part of [setting up API key config](#setup-config-for-ibm-api-key)
* Make sure the ssh key for Region 2 VPC is created as part of [create SSH key](#create-ssh-key-to-work-with-vpc)

### Setup Region 2 infrastructure
* Terraform is used to setup the infrastructure for region1. Perform setup of region 2 (cluster1/cluster2)
  by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm/dallas
  cp $MAIN_CONFIG_DIR/terraform-ibm/toronto/terraform.tfvars .
  terraform init
  terraform apply -auto-approve \
    -var PREFIX="cob-test" \
    -var CLUSTER1_PRIVATE_IP_PREFIX="10.75" \
    -var CLUSTER2_PRIVATE_IP_PREFIX="10.76"

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

<br>

## Global Transit Gateway setup
This section contains information on setting up transit gateways for communications between:
* Cluster1 and Cluster3 - between different regions
* Cluster2 and Cluster4 - between different regions

### Prerequisites - transit gateway setup
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

### Transit Gateway config
* Perform setup of Transit Gateways by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm/transit-gateway/global
  terraform init
  cp $MAIN_CONFIG_DIR/terraform-ibm/toronto/terraform.tfvars .
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


## Configure Region 1/2 - ansible
Ansible is used to configure brokers/routers and NFS server to install required packages as well as running
them. _For this purpose, we need to run two manual steps before we can use ansible to configure the system_

### Prerequisites - Ansible config
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

### Capture public IP - Manual step
To configure the instances using ansible, we need to extract the public ip for all the instances first.
* Execute following commands to retrieve public ip for region 1 and 2:
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm

  # Command given below will extract the public IP for all the instances running in region 1
  ./capture_ip_host.sh -r r1 -d toronto -s "_ip" -a

  # Command given below will extract the public IP for all the instances running in region 2
  ./capture_ip_host.sh -r r2 -d dallas -s "_ip" -a
  ```
  Copy the `<hostname>: <ip_address>` output (_between START and END tags_), for each of the above commands,
  to `$MAIN_CONFIG_DIR/ansible/variable_override.yml`

### Create vault password - Manual step
* Create a file named `.vault_password` in `$MAIN_CONFIG_DIR/ansible` directory with it contents set to following text
  * `password`
* Run following command to set the correct username/password for Red Hat login:
  * `ansible-vault edit group_vars/routers/vault`
    * _Above command will open up an editor_
  * Provide values for following keys (**_This is the Red Hat SSO user/password and not the Mac/Linux user/password_**):
    * `redhat_username`  (_replace `PROVIDE_CORRECT_USERNAME` with correct username_)
    * `redhat_password`  (_replace `PROVIDE_CORRECT_PASSWORD` with correct password_)

### SSL Setup
* You can setup Brokers & Routers with SSL and the SSL behavior is determined by the SSL variables in `$MAIN_CONFIG_DIR/ansible/variable_override.yml`. 
* In most cases just changing (_enable_ssl_) & (_ssl_generate_ca_) should be sufficient and one can change other variables based on specific requirements.

|Variable|Description|
|-----|-----|
| enable_ssl | Enable SSL config in brokers and routers |
| ssl_generate_ca | Whether to generate CA Certificates. For the very first run of the scripts, set this to true, for subsequent runs you may set this to false for reusing the existing CA certificates.|
| ssl_generate_certs | Whether to generate server certificate. For the very first run of the scripts, set this to true, for subsequent runs you may set this to false for reusing the existing certificates. |

### Configure regions
* Perform configuration setup of cluster1 and cluster2 in region 1/2 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/ansible

  # Below commands will NOT setup mirroring between the two regions
  ansible-playbook -i hosts/hosts.yml playbooks/setup_playbook.yml --extra-vars "@variable_override.yml"
  ansible-playbook -i hosts/hosts.yml playbooks/run_broker_n_router_playbook.yml --extra-vars "@variable_override.yml"
  ```
* Above command(s) will configure following resources:
  * `amq_runner` user will be created in all the instances of brokers and routers
  * Necessary packages will be installed in the NFS server, brokers and routers
  * NFS mount points will be created between brokers and NFS server
  * Host entries will be added to the brokers (for NFS server) and spoke routers (for hub router and brokers)
  * All the brokers will start
  * All the routers will start

## Run performance tests
JMeter is being used to run the performance tests on the AMQ brokers and routers.

### Running Jmeter test using Ansible.
Refer this documentation to [perform Jmeter tests using Ansible](readme-jmeter.md)

## Other ansible plays
Ansible can be used to perform other tasks, e.g. reset the config, stop, run the brokers/routers

### Prerequisites - other ansible plays
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

### Reset regions
* One can reset the brokers/routers/nfs server to bring them to the initial state by running following commands: 
  ```shell
  cd $MAIN_CONFIG_DIR/ansible
  ansible-playbook -i hosts/hosts.yml playbooks/reset_playbook.yml --extra-vars "@variable_override.yml"
  ```
* Above command(s) will perform following tasks:
  * Stop broker instances
  * Stop router instances
  * Remove installed packages for brokers/routers/nfs server
  * Remove host entries
  * Remove user/groups that were setup by ansible
  * Remove all the user directories and any other directories created as part of ansible setup

### Stop brokers/routers
* To stop the running brokers/routers, execute following commands 
  ```shell
  cd $MAIN_CONFIG_DIR/ansible
  ansible-playbook -i hosts/hosts.yml playbooks/stop_broker_n_router_playbook.yml --extra-vars "@variable_override.yml"
  ```
* Above command(s) will perform following tasks:
  * Stop broker instances
  * Stop router instances

### Run brokers/routers
* To stop the running brokers/routers, execute following commands 
  ```shell
  cd $MAIN_CONFIG_DIR/ansible
  ansible-playbook -i hosts/hosts.yml playbooks/run_broker_n_router_playbook.yml --extra-vars "@variable_override.yml"
  ```
* Above command(s) will perform following tasks:
  * Run broker instances
  * Run router instances

### Purge queue
* While doing performance test the queue might need to be purged. There are two ways to do so:
  1. Using ansible scripts:
    ```shell
    cd $MAIN_CONFIG_DIR/ansible
    ansible-playbook -i hosts/hosts.yml playbooks/purge_queue_playbook.yml --extra-vars "@variable_override.yml"
    ```
  2. **TODO - will be provided by Kamlesh**
* Above command(s) will purge `exampleQueue` on all the live AMQ brokers in region 1 and 2.
  _The name of the queue can be overridden from command line by specifying `amq_queue` variable in `variable_override.yml` file_

<br>
<br>


## Start/stop the instances
Sometimes you may need to stop the running instances, or start the instances that are stopped. This section provides
information on that process

### Prerequisites - start/stop instances
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

### Start instances - Region 1/2
* To start instances in region 1 and 2, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/start-stop-instance
    terraform apply -auto-approve \
      -var PREFIX="cob-test" \
      -var INSTANCE_ACTION="start" \
      -var FORCE_ACTION="false"
  ```

### Stop instances - Region 1/2
* To perform a graceful shutdown, first execute steps given in [Stop broker and routers](#stop-brokersrouters)
* Stop running instances in region 1 and 2 by perform following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/start-stop-instance
    terraform apply -auto-approve \
      -var PREFIX="cob-test" \
      -var INSTANCE_ACTION="stop" \
      -var FORCE_ACTION="false"
  ```

_Above command will take a few minutes and will either start or stop the instances (depending on the action)_
<br>
<br>

## Destroy the resources
This section provides information on how to cleanup / delete the resources that were setup for all the clusters in
the two regions

### Prerequisites - destroy resources
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

### Destroy Global Transit Gateway
* To delete the Global Transit Gateway, use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/transit-gateway/global
    terraform plan -destroy -out=destroy.plan \
      -var PREFIX="cob-test"
    terraform apply destroy.plan
  ```

### Destroy resources - Region 1
* To delete resources setup in region 1 (cluster 1/2), use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/toronto
    terraform plan -destroy -out=destroy.plan \
      -var PREFIX="cob-test" \
      -var CLUSTER1_PRIVATE_IP_PREFIX="10.70" \
      -var CLUSTER2_PRIVATE_IP_PREFIX="10.71"
    terraform apply destroy.plan
  ```

### Destroy resources - Region 2
* To delete resources setup in region 2 (cluster 1/2), use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/dallas
    terraform plan -destroy -out=destroy.plan \
      -var PREFIX="cob-test" \
      -var CLUSTER1_PRIVATE_IP_PREFIX="10.75" \
      -var CLUSTER2_PRIVATE_IP_PREFIX="10.76"
    terraform apply destroy.plan
  ```

<hr style="height:1px"/>

<br>
<br>


## Instance info
This section provides region / zone / private IP address for each of the instance setup in this project
<br>

| Region  | Cluster  | VPC info                      | Instance info | Private IP     | Zone info  | Description |
| ------- | -------- | ----------------------------- | ------------- | -------------- | ---------- | ----------- |
| Toronto | Cluster1 | `cob-test-amq-vpc-ca-tor-1`   | NFS           | `10.70.0.50`   | ca-tor-1   | NFS server in Toronto zone 1 |
|         |          |                               | Broker-01     | `10.70.0.51`   | ca-tor-1   | Live1 broker in Toronto zone 1 |
|         |          |                               | Broker-02     | `10.70.64.51`  | ca-tor-2   | Backup1 (of Broker 01) broker in Toronto zone 2 |
|         |          |                               | Broker-03     | `10.70.128.51` | ca-tor-3   | Live2 broker in Toronto zone 3 |
|         |          |                               | Broker-04     | `10.70.0.52`   | ca-tor-1   | Backup2 (backup of Broker 03) broker in Toronto zone 1 |
|         |          |                               | Router-01     | `10.70.128.100` | ca-tor-3   | Hub router in Toronto zone 3 |
|         |          |                               | Router-02     | `10.70.64.100` | ca-tor-2   | Spoke router in Toronto zone 2 - connecting to Cluster1 |
|         | Cluster2 | `cob-test-amq-vpc-ca-tor-2`   | NFS           | `10.71.0.50`   | ca-tor-1   | NFS server in Toronto zone 1 |
|         |          |                               | Broker-05     | `10.71.128.61` | ca-tor-3   | Live3 broker in Toronto zone 3 |
|         |          |                               | Broker-06     | `10.71.64.61`  | ca-tor-2   | Backup3 (of Broker 05) broker in Toronto zone 2 |
|         |          |                               | Broker-07     | `10.71.0.61`   | ca-tor-1   | Live4 broker in Toronto zone 1 |
|         |          |                               | Broker-08     | `10.71.128.62` | ca-tor-3   | Backup4 (backup of Broker 07) broker in Toronto zone 1 |
|         |          |                               | Router-03     | `10.71.0.100`  | ca-tor-1   | Spoke router in Toronto zone 1 - connecting to Cluster2 |
| Dallas  | Cluster1 | `cob-test-amq-vpc-us-south-1` | NFS           | `10.75.0.50`   | us-south-1 | NFS server in Dallas zone 1 |
|         |          |                               | Broker-01     | `10.75.0.51`   | us-south-1 | Live5 broker in Dallas zone 1 |
|         |          |                               | Broker-02     | `10.75.64.51`  | us-south-2 | Backup5 broker (backup of Broker 09) in Dallas zone 2 |
|         |          |                               | Broker-03     | `10.75.128.51` | us-south-3 | Live5 broker in Dallas zone 3 |
|         |          |                               | Broker-04     | `10.75.0.52`   | us-south-1 | Backup6 broker (backup of Broker 11) in Dallas zone 1 |
|         |          |                               | Router-01     | `10.75.128.100` | us-south-3 | Hub router in Dallas zone 3 |
|         |          |                               | Router-02     | `10.75.64.100` | us-south-2 | Spoke router in Dallas zone 2 - connecting to Cluster1 |
|         | Cluster4 | `cob-test-amq-vpc-us-south-2` | NFS           | `10.76.64.60`  | us-south-1 | NFS server in Dallas zone 2 |
|         |          |                               | Broker-05     | `10.76.128.61` | us-south-1 | Live7 broker in Dallas zone 3 |
|         |          |                               | Broker-06     | `10.76.0.61`   | us-south-2 | Backup7 broker (backup of Broker 13) in Dallas zone 1 |
|         |          |                               | Broker-07     | `10.76.64.61`  | us-south-3 | Live8 broker in Dallas zone 2 |
|         |          |                               | Broker-08     | `10.76.0.62`   | us-south-1 | Backup8 broker (backup of Broker 15) in Dallas zone 1 |
|         |          |                               | Router-03     | `10.76.0.100`  | us-south-2 | Spoke router in Dallas zone 1 - connecting to Cluster4 |



## Setup Region 1 - tmp
Region 1 is setup in **Toronto** that has two clusters:
* **Cluster1** - consisting of following four brokers:
  * `broker01` - live/primary
  * `broker02` - backup of broker01
  * `broker03` - live/primary
  * `broker04` - backup of broker03

As part of cluster1 config, following interconnect routers are also created and setup (in the same VPC):
* router01 - Hub router - accepts connections from consumers/producers
* router02 - Spoke router - connects to live brokers in Cluster1 and also to Hub router (router01)

### Prerequisites - Region 1 - tmp
* _`MAIN_CONFIG_DIR` environment variable should be setup as part of [Checkout config](#checkout-setup-config) step_

<br>

### Setup config for IBM API key - tmp
* Create a file named `terraform.tfvars`, _in `$MAIN_CONFIG_DIR/terraform-ibm/toronto-vpc1` directory_, with following content:
  ```shell
  ibmcloud_api_key = "<YOUR_IBM_CLOUD_API_KEY>"
  ssh_key = "<NAME_OF_YOUR_SSH_KEY>"
  ```
  _Substitute with your actual IBM Cloud API key here_

<br>

### Setup Region 1 infrastructure - tmp
* Terraform is used to setup the infrastructure for region1. Perform infrastructure setup of region 1
  (cluster1/cluster2) by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm/toronto-vpc1
  terraform init
  terraform apply -auto-approve \
    -var PREFIX="appeng-381" \
    -var CLUSTER1_PRIVATE_IP_PREFIX="10.101" \
    -var CLUSTER2_PRIVATE_IP_PREFIX="10.102"
  ```
  * _All resources created will have the PREFIX provided in the last command_
* Above command will take around 5-7 minutes and should create following resources:
  * **VPC**: `appeng-381-amq-vpc-ca-tor-1`
    * Subnets:
      * `appeng-381-vpc-ca-tor-subnet-01-ca-tor-1`
      * `appeng-381-vpc-ca-tor-subnet-02-ca-tor-2`
      * `appeng-381-vpc-ca-tor-subnet-03-ca-tor-3`
    * Security groups named:
      * `appeng-381-vpc-ca-tor-sec-grp-01`
        * This security group adds an inbound rule for ssh and ping
      * `appeng-381-vpc-ca-tor-sec-grp-02`
        * This security group adds inbound rules to allow access to following ports:
          * `5672`  - AMQP broker amqp accepts connection on this port
          * `8161`  - AMQ console listens on this port
          * `61616` - AMQ broker artemis accepts connection on this port
      * `appeng-381-vpc-ca-tor-sec-grp-03`
        * Adds an inbound rule on port `5773` that will be used by the Hub router to listen for incoming connections
    * VSIs (Virtual Server Instance):
      * NFS server: `appeng-381-ca-tor-1-nfs-server-01`
      * Broker01: `appeng-381-broker01-live1`
      * Broker02: `appeng-381-broker02-bak1`
      * Broker03: `appeng-381-broker03-live2`
      * Broker04: `appeng-381-broker04-bak2`
      * Router01 (hub): `appeng-381-hub-router1`
      * Router02 (spoke): `appeng-381-spoke-router2`
    * Floating IPs (Public IPs) for each of the above VSI (Virtual Server Instance)

<br>



### Configure Region 1 - ansible - tmp
Ansible is used to configure brokers/routers and NFS server to install required packages as well as running
them.

#### Create vault password - tmp
* Follow the steps given in [Create vault password](#create-vault-password)

#### Configure region - tmp
* Perform configuration setup of cluster1 in region 1 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/terraform-ibm

  # Command given below will extract the public IP for all the instances running in VPC1 (cluster1)
  ./capture_ip_host.sh -r r1 -d toronto-vpc1 -s "_ip" -a
  ```
  Copy the `<hostname>: <ip_address>` output (_between START and END tags_) to `$MAIN_CONFIG_DIR/ansible/variable_override.yml`
* Perform configuration setup of cluster1 in region 1 by running following commands
  ```shell
  cd $MAIN_CONFIG_DIR/ansible

  # Below commands will NOT setup mirroring between the two regions
  ansible-playbook -i hosts-r1_vpc1.yml setup_playbook.yml --extra-vars "@variable_override.yml"
  ansible-playbook -i hosts-r1_vpc1.yml run_broker_n_router_playbook.yml --extra-vars "@variable_override.yml"
  ```
* Above command(s) will configure following resources:
  * `amq_runner` user will be created in all the instances of brokers and routers
  * Necessary packages will be installed in the NFS server, brokers and routers
  * NFS mount points will be created between brokers and NFS server
  * Host entries will be added to the brokers (for NFS server) and spoke routers (for hub router and brokers)
  * All the brokers will start
  * All the routers will start

<br>
<br>

## Destroy the resources - tmp
This section provides information on how to cleanup / delete the resources that were setup for all the clusters in
the Toronto region (cluster 1)

### Destroy resources - Region 1 - tmp
* To delete resources setup in region 1 (cluster 1), use following commands:
  ```shell
    cd $MAIN_CONFIG_DIR/terraform-ibm/toronto-vpc1
    terraform plan -destroy -out=destroy.plan \
      -var PREFIX="appeng-381" \
      -var CLUSTER1_PRIVATE_IP_PREFIX="10.101" \
      -var CLUSTER2_PRIVATE_IP_PREFIX="10.102"
    terraform apply destroy.plan
  ```

## References
* [Hub and spoke router topology setup](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/manualconfig/routertopology/fanout)
* [AMQ Interconnect Router - Hub and Spoke network](https://access.redhat.com/documentation/en-us/red_hat_amq/7.4/html-single/using_amq_interconnect/index#connecting-routers-router)
* [Terraform config location](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/automation/terraform)
* [Ansible config location](https://github.com/RHEcosystemAppEng/amq-cob/tree/master/automation/ansible)

