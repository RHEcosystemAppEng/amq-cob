variable "MAIN_CIDR_BLOCK" {}

variable "NAME_PREFIX" {}

variable "REGION" {}
variable "IP_NUMBER_PREFIX" {
  type = map
}

variable "CIDR_BLOCKS" {
  type = map
}

variable "PREFIX" {}
variable "ssh_key" {}
variable "AMI_ID" {}
variable "AMI_NAME" {}
variable "PRIVATE_IP_PREFIX" {}

variable "TAGS" {}
