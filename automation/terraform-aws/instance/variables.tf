
variable "SSH_KEY" {}

variable "INSTANCE_TYPE" {
  default = "t2.medium"
}

variable "AMI_ID" {}
variable "AMI_NAME" {}
variable "PRIVATE_IP" {}

variable "SUBNET_ID" {}
variable "SECURITY_GROUP_IDS" {
  type = list(string)
}

variable "INSTANCE_NAME" {}

variable "TAGS" {}
