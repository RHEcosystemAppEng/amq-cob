variable "MAIN_CIDR_BLOCK" {}

variable "NAME_PREFIX" {}

variable "REGION" {}
variable "IP_NUMBER_PREFIX" {
  type = map
}

variable "CIDR_BLOCKS" {
  type = map
}

variable "INSTANCE_INFO" {
  type = map
}

variable "PREFIX" {}
variable "SSH_KEY" {}
variable "AMI_ID" {}
variable "AMI_NAME" {}
variable "PRIVATE_IP_PREFIX" {}
variable "INSTANCE_TYPE" {}

variable "TAGS" {}
