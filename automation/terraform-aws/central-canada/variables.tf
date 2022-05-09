
variable "PREFIX" {
  default = "PROVIDE_VALUE_ON_CLI"
}

variable "SSH_KEY" {}

variable "REGION" {
  default = "ca-central-1"
}

# Canada
variable "REGION_CENTRAL" {
  default = "ca-central-1"
}

variable "AMI_NAME_CENTRAL" {
  default = "RHEL_HA-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
}

variable "AMI_ID_CENTRAL" {
  default = "ami-0277fbe7afa8a33a6"
}

# N. California
variable "REGION_US_WEST_1" {
  default = "us-west-1"
}

variable "AMI_NAME_US_WEST_1" {
  default = "RHEL_HA-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
}

variable "AMI_ID_US_WEST_1" {
  default = "ami-054965c6cd7c6e462"
}

# Oregon
variable "REGION_US_WEST_2" {
  default = "us-west-2"
}

variable "AMI_NAME_US_WEST_2" {
  default = "RHEL_HA-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
}

variable "AMI_ID_US_WEST_2" {
  default = "ami-0b28dfc7adc325ef4"
}

# N. Virginia
variable "REGION_US_EAST_1" {
  default = "us-east-1"
}

variable "AMI_NAME_US_EAST_1" {
  default = "RHEL-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
}

variable "AMI_ID_US_EAST_1" {
  default = "ami-0b0af3577fe5e3532"
}

# Ohio
variable "REGION_US_EAST_2" {
  default = "us-east-2"
}

variable "AMI_NAME_US_EAST_2" {
  default = "RHEL-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
}

variable "AMI_ID_US_EAST_2" {
  default = "ami-0ba62214afa52bec7"
}

# This variable should be defined on the cli
variable "CLUSTER1_PRIVATE_IP_PREFIX" {
  #  default = "10.101"
}

variable "SUBNET_1_3RD_OCTET" {
  default = "100"
}

variable "SUBNET_2_3RD_OCTET" {
  default = "101"
}

variable "SUBNET_3_3RD_OCTET" {
  default = "102"
}

variable "SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP" {
  default = true
}

# https://aws.amazon.com/ec2/instance-types/
variable "INSTANCE_TYPE" {
  default = "t2.large"
}

variable "CIDR_BLOCK_ALL" {
  default = "0.0.0.0/0"
}

variable "SEC_GRP_EGRESS_FROM_PORT" {
  default = 0
}

variable "SEC_GRP_EGRESS_TO_PORT" {
  default = 0
}

variable "SEC_GRP_EGRESS_PROTOCOL" {
  default = "-1"
}

variable "SEC_GRP_EGRESS_PROTOCOL_ALL" {
  default = "all"
}

variable "SEC_GRP_EGRESS_IPV6_CIDR_BLOCK" {
  default = ["::/0"]
}

variable "tags" {
  type    = map(string)
  default = {
    jira : "appeng-588",
    project : "fsi-amq_cob_team",
    created_by : "terraform"
  }
  description = "provides tags for all the resources crated here"
}
