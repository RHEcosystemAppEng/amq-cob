variable "PREFIX" {
  default = "PROVIDE_VALUE_ON_CLI"
}

variable "SSH_KEY" {}

# Override REGION from CLI if they need to be something other than the default value
variable "REGION" {
  default = "us-east-2"
}

variable "AMI" {
  type = map(string)

  default = {
    "ca-central-1" : "ami-0c3d3a230b9668c02"       // Canada
    "us-east-1" : "ami-06640050dc3f556bb"          // N. Virginia
    "us-east-2" : "ami-092b43193629811af"          // Ohio
    "us-west-1" : "ami-0186e3fec9b0283ee"          // N. California
    "us-west-2" : "ami-08970fb2e5767e3b8"          // Oregon
  }
}

variable "AMI_NAME" {
  // The AMIs (in any given region) is "RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"
  default = "RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"
}

variable "VPC1_PRIVATE_IP_PREFIX" {
  default = "10.110"
}

variable "VPC2_PRIVATE_IP_PREFIX" {
  default = "10.111"
}

variable "SUBNET_1_3RD_OCTET" {
  default = "0"
}

variable "SUBNET_2_3RD_OCTET" {
  default = "64"
}

variable "SUBNET_3_3RD_OCTET" {
  default = "128"
}

variable "SUBNET_ENABLE_AUTO_ASSIGN_PUBLIC_IP" {
  default = true
}

# https://aws.amazon.com/ec2/instance-types/
variable "INSTANCE_TYPE" {
#  default = "t3.xlarge"
    default = "c4.xlarge"
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
