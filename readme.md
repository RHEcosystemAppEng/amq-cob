
# Intro
**DO NOT MERGE THIS BRANCH INTO main BRANCH** as main branch uses Transit Gateway to establish VPC connectivity.

Repo for config that is used to setup AMQ brokers and Interconnect Routers using Ansible and Terraform in AWS and IBM Cloud for DR/HA testing.

_The setup is tested using JMeter._

## Intra-region and inter-region VPC connectivity
_**VPC peering** is used to establish connectivity between the VPCs, in the same region as well as between different regions._

## Directories that are part of this repo:
* ansible
  * Contains Ansible config to automatically setup/start/stop AMQ brokers / Interconnect routers / NAS etc.
* terraform
  * Contains Terraform config that is used to provision the infrastructure on AWS
* terraform-ibm
  * Contains Terraform config that is used to provision the infrastructure on IBM Cloud
* others
  * Contains manual config instructions
  * Test non-JMeter clients used earlier in the testing
  * Java classes to purge broker queues

## Configuring AMQ DR

Follow the links given below to perform the setup on either AWS or IBM Cloud.

* [AWS](readme-aws.md)
* [IBM Cloud](readme-ibm.md)

