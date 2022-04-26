locals {

  MAIN_CIDR_BLOCK = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.0/16"

  NAME_PREFIX = "${var.PREFIX} - AMQ COB"

  REGION_N_AMI = {
    (var.REGION_CENTRAL) : {
      ami_name : var.AMI_NAME_CENTRAL,
      ami_id : var.AMI_ID_CENTRAL,
      cidr_zones : ["1", "3"]
    }
    (var.REGION_US_EAST_1) : {
      ami_name : var.AMI_NAME_US_EAST_1,
      ami_id : var.AMI_ID_US_EAST_1,
      cidr_zones : ["1", "2", "3"]
    }
    (var.REGION_US_EAST_2) : {
      ami_name : var.AMI_NAME_US_EAST_2,
      ami_id : var.AMI_ID_US_EAST_2,
      cidr_zones : ["1", "2", "3"]
    }
    (var.REGION_US_WEST_1) : {
      ami_name : var.AMI_NAME_US_WEST_1,
      ami_id : var.AMI_ID_US_WEST_1,
      cidr_zones : ["1", "3"]
    }
    (var.REGION_US_WEST_2) : {
      ami_name : var.AMI_NAME_US_WEST_2,
      ami_id : var.AMI_ID_US_WEST_2,
      cidr_zones : ["1", "3"]
    }
  }

  CIDR_BLOCKS = {
    "0" : { cidr : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.100.0/24" }  # 255 addresses
    "1" : { cidr : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.101.0/24" }  # 255 addresses
    "2" : { cidr : "${var.CLUSTER1_PRIVATE_IP_PREFIX}.102.0/24" }  # 255 addresses
  }

  MAIN_TAGS = merge(
    var.tags,
    {
      Name : local.NAME_PREFIX
    }
  )
}
