locals {
  VPC1_MAIN_CIDR_BLOCK = "${var.VPC1_PRIVATE_IP_PREFIX}.0.0/16"
  VPC2_MAIN_CIDR_BLOCK = "${var.VPC2_PRIVATE_IP_PREFIX}.0.0/16"

  NAME_PREFIX = "${var.PREFIX}-AMQ_COB"
  AMI_ID      = lookup(var.AMI, var.REGION)

  KEY_NFS       = "nfs"
  KEY_BROKER_01 = "broker_01"
  KEY_BROKER_02 = "broker_02"
  KEY_BROKER_03 = "broker_03"
  KEY_BROKER_04 = "broker_04"

  VPC1_IP_NUMBER_PREFIX = {
    "0" : "${var.VPC1_PRIVATE_IP_PREFIX}.${var.SUBNET_1_3RD_OCTET}"
    "1" : "${var.VPC1_PRIVATE_IP_PREFIX}.${var.SUBNET_2_3RD_OCTET}"
    "2" : "${var.VPC1_PRIVATE_IP_PREFIX}.${var.SUBNET_3_3RD_OCTET}"
  }

  VPC2_IP_NUMBER_PREFIX = {
    "0" : "${var.VPC2_PRIVATE_IP_PREFIX}.${var.SUBNET_1_3RD_OCTET}"
    "1" : "${var.VPC2_PRIVATE_IP_PREFIX}.${var.SUBNET_2_3RD_OCTET}"
    "2" : "${var.VPC2_PRIVATE_IP_PREFIX}.${var.SUBNET_3_3RD_OCTET}"
  }
}
