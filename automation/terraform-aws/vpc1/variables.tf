variable "MAIN_CIDR_BLOCK" {}

variable "NAME_PREFIX" {}

variable "REGION" {}
variable "IP_NUMBER_PREFIX" {
  type = map
}

variable "PREFIX" {}
variable "SSH_KEY" {}
variable "AMI_ID" {}
variable "AMI_NAME" {}
variable "PRIVATE_IP_PREFIX" {}
variable "INSTANCE_TYPE" {}

variable "KEY_NFS" {}
variable "KEY_BROKER_01" {}
variable "KEY_BROKER_02" {}
variable "KEY_BROKER_03" {}
variable "KEY_BROKER_04" {}

variable "TAGS" {}
