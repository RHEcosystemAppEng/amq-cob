

#locals {
#
#  MAIN_CIDR_BLOCK = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.0/16"
#
#  NAME_PREFIX = "${var.PREFIX} - AMQ COB"
#
#  REGION_N_AMI = {
#    (var.REGION_CENTRAL) : {
#      ami_name : var.AMI_NAME_CENTRAL,
#      ami_id : var.AMI_ID_CENTRAL
#    }
#    (var.REGION_US_EAST_1) : {
#      ami_name : var.AMI_NAME_US_EAST_1,
#      ami_id : var.AMI_ID_US_EAST_1
#    }
#    (var.REGION_US_EAST_2) : {
#      ami_name : var.AMI_NAME_US_EAST_2,
#      ami_id : var.AMI_ID_US_EAST_2
#    }
#    (var.REGION_US_WEST_1) : {
#      ami_name : var.AMI_NAME_US_WEST_1,
#      ami_id : var.AMI_ID_US_WEST_1
#    }
#    (var.REGION_US_WEST_2) : {
#      ami_name : var.AMI_NAME_US_WEST_2,
#      ami_id : var.AMI_ID_US_WEST_2
#    }
#  }
#
#  IP_NUMBER_PREFIX = {
#    "0" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.100"
#    "1" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.101"
#    "2" : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.102"
#  }
#
#  CIDR_BLOCKS = {
#    "0" : { cidr : "${local.IP_NUMBER_PREFIX.0}.0/24" }  # 255 addresses
#    "1" : { cidr : "${local.IP_NUMBER_PREFIX.1}.0/24" }  # 255 addresses
#    "2" : { cidr : "${local.IP_NUMBER_PREFIX.2}.0/24" }  # 255 addresses
#  }
#
#  MAIN_TAGS = merge(
#    var.tags,
#    {
#      Name : local.NAME_PREFIX
#    }
#  )
#
#
#}
