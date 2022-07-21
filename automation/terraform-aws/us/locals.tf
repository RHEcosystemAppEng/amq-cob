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

  KEY_NFS = "nfs"
  KEY_BROKER_01 = "broker_01"
  KEY_BROKER_02 = "broker_02"
  KEY_BROKER_03 = "broker_03"
  KEY_BROKER_04 = "broker_04"
  KEY_ROUTER_01 = "router_01"
  KEY_ROUTER_02 = "router_02"
  KEY_ROUTER_03 = "router_03"

  CLUSTER1_INSTANCE_INFO = {
    (local.KEY_NFS) : {
      suffix : "nfs-server-01", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.0}.50", main_zone : "1"
    }
    (local.KEY_BROKER_01) : {
      suffix : "broker01-live1", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.0}.51", main_zone : "1"
    }
    (local.KEY_BROKER_02) : {
      suffix : "broker02-bak1", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.1}.51", main_zone : "2"
    }
    (local.KEY_BROKER_03) : {
      suffix : "broker03-live2", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.1}.52", main_zone : "2"
    }
    (local.KEY_BROKER_04) : {
      suffix : "broker04-bak2", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.0}.52", main_zone : "1"
    }
    (local.KEY_ROUTER_01) : {
      suffix : "hub-router1", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.1}.100", main_zone : "2"
    }
    (local.KEY_ROUTER_02) : {
      suffix : "spoke-router2", private_ip : "${local.CLUSTER1_IP_NUMBER_PREFIX.0}.101", main_zone : "1"
    }
  }

  CLUSTER2_INSTANCE_INFO = {
    (local.KEY_NFS) : {
      suffix : "nfs-server-02", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.1}.60", main_zone : "2"
    }
    (local.KEY_BROKER_01) : {
      suffix : "broker05-live1", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.1}.61", main_zone : "2"
    }
    (local.KEY_BROKER_02) : {
      suffix : "broker06-bak1", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.0}.61", main_zone : "1"
    }
    (local.KEY_BROKER_03) : {
      suffix : "broker07-live2", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.0}.62", main_zone : "1"
    }
    (local.KEY_BROKER_04) : {
      suffix : "broker08-bak2", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.1}.62", main_zone : "2"
    }
    (local.KEY_ROUTER_03) : {
      suffix : "spoke-router3", private_ip : "${local.CLUSTER2_IP_NUMBER_PREFIX.1}.102", main_zone : "2"
    }
  }
}
