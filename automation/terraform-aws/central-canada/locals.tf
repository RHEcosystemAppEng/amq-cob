locals {

  CLUSTER1_MAIN_CIDR_BLOCK = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.0/16"
  CLUSTER2_MAIN_CIDR_BLOCK = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.0.0/16"

  NAME_PREFIX = "${var.PREFIX}-AMQ_COB"

  REGION_N_AMI = {
    (var.REGION_CENTRAL) : {
      ami_name : var.AMI_NAME_CENTRAL,
      ami_id : var.AMI_ID_CENTRAL
    }
    (var.REGION_US_EAST_1) : {
      ami_name : var.AMI_NAME_US_EAST_1,
      ami_id : var.AMI_ID_US_EAST_1
    }
    (var.REGION_US_EAST_2) : {
      ami_name : var.AMI_NAME_US_EAST_2,
      ami_id : var.AMI_ID_US_EAST_2
    }
    (var.REGION_US_WEST_1) : {
      ami_name : var.AMI_NAME_US_WEST_1,
      ami_id : var.AMI_ID_US_WEST_1
    }
    (var.REGION_US_WEST_2) : {
      ami_name : var.AMI_NAME_US_WEST_2,
      ami_id : var.AMI_ID_US_WEST_2
    }
  }

  CLUSTER1_IP_NUMBER_PREFIX = {
    "0" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.${var.SUBNET_1_3RD_OCTET}"
    "1" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.${var.SUBNET_2_3RD_OCTET}"
    "2" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.${var.SUBNET_3_3RD_OCTET}"
  }

  CLUSTER1_CIDR_BLOCKS = {
    "0" : { cidr : "${local.CLUSTER1_IP_NUMBER_PREFIX.0}.0/24" }  # 255 addresses
    "1" : { cidr : "${local.CLUSTER1_IP_NUMBER_PREFIX.1}.0/24" }  # 255 addresses
    "2" : { cidr : "${local.CLUSTER1_IP_NUMBER_PREFIX.2}.0/24" }  # 255 addresses
  }

  CLUSTER2_IP_NUMBER_PREFIX = {
    "0" : "${var.CLUSTER2_PRIVATE_IP_PREFIX}.${var.SUBNET_1_3RD_OCTET}"
    "1" : "${var.CLUSTER2_PRIVATE_IP_PREFIX}.${var.SUBNET_2_3RD_OCTET}"
    "2" : "${var.CLUSTER2_PRIVATE_IP_PREFIX}.${var.SUBNET_3_3RD_OCTET}"
  }

  CLUSTER2_CIDR_BLOCKS = {
    "0" : { cidr : "${local.CLUSTER2_IP_NUMBER_PREFIX.0}.0/24" }  # 255 addresses
    "1" : { cidr : "${local.CLUSTER2_IP_NUMBER_PREFIX.1}.0/24" }  # 255 addresses
    "2" : { cidr : "${local.CLUSTER2_IP_NUMBER_PREFIX.2}.0/24" }  # 255 addresses
  }


#  VPC_NAME_PREFIX       = "${var.PREFIX}-vpc-${var.REGION}"
#  SUBNET_PREFIX         = "${local.VPC_NAME_PREFIX}-subnet"
#  SECURITY_GROUP_PREFIX = "${local.VPC_NAME_PREFIX}-sec-grp"
#
#  CLUSTER1_VPC_NAME = "${local.VPC_NAME_PREFIX}-1"
#  CLUSTER2_VPC_NAME = "${local.VPC_NAME_PREFIX}-2"
}
