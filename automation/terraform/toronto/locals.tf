locals {
  REGION = var.REGION

  ZONE1 = "${local.REGION}-1"
  ZONE2 = "${local.REGION}-2"
  ZONE3 = "${local.REGION}-3"

  CLUSTER1_ZONE1_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.0/18"
  CLUSTER1_ZONE2_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.64.0/18"
  CLUSTER1_ZONE3_CIDR = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.128.0/18"

  CLUSTER2_ZONE1_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.0.0/18"
  CLUSTER2_ZONE2_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.64.0/18"
  CLUSTER2_ZONE3_CIDR = "${var.CLUSTER2_PRIVATE_IP_PREFIX}.128.0/18"

  INSTANCE_PROFILE = "bx2-2x8"

  #  CLUSTER1_NFS_SUFFIX         = "nfs-server"
  #  CLUSTER1_NFS_PRIVATE_IP     = "${var.CLUSTER1_PRIVATE_IP_PREFIX}.0.50"
  #  CLUSTER1_NFS_MAIN_ZONE      = local.ZONE1
  #  CLUSTER1_NFS_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone
  #
  #  CLUSTER1_BROKER_01_SUFFIX         = "broker01-live1"
  #  CLUSTER1_BROKER_01_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.51"
  #  CLUSTER1_BROKER_01_MAIN_ZONE      = local.ZONE1
  #  CLUSTER1_BROKER_01_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone
  #
  #  CLUSTER1_BROKER_02_SUFFIX         = "broker02-bak1"
  #  CLUSTER1_BROKER_02_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.51"
  #  CLUSTER1_BROKER_02_MAIN_ZONE      = local.ZONE2
  #  CLUSTER1_BROKER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  VPC_NAME_PREFIX       = "${var.PREFIX}-vpc-${var.REGION}"
  SUBNET_PREFIX         = "${local.VPC_NAME_PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${local.VPC_NAME_PREFIX}-sec-grp"

  CLUSTER1_VPC_NAME                        = "${local.VPC_NAME_PREFIX}-1"
  CLUSTER1_VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.CLUSTER1_VPC_NAME}-default-sg"

  CLUSTER2_VPC_NAME                        = "${local.VPC_NAME_PREFIX}-2"
  CLUSTER2_VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.CLUSTER2_VPC_NAME}-default-sg"


  # User data scripts are relative to the cluster they're invoked from
  CLUSTER1_NFS_SERVER_USER_DATA_FILE      = "../nfs/files/initial_setup-region2_cluster1.sh"
  CLUSTER1_BROKER_01_USER_DATA_FILE       = "../broker/region1/cluster1/broker1_live1/initial_setup-01.sh"
  CLUSTER1_BROKER_02_USER_DATA_FILE       = "../broker/region1/cluster1/broker2_bak1/initial_setup-01.sh"
  CLUSTER1_BROKER_03_USER_DATA_FILE       = "../broker/region1/cluster1/broker3_live2/initial_setup-01.sh"
  CLUSTER1_BROKER_04_USER_DATA_FILE       = "../broker/region1/cluster1/broker4_bak2/initial_setup-01.sh"
  CLUSTER1_ROUTER_01_HUB_USER_DATA_FILE   = "../router/hub-router1/region1-initial_setup-01.sh"
  CLUSTER1_ROUTER_02_SPOKE_USER_DATA_FILE = "../router/spoke-router2/region1-initial_setup-01.sh"

  CLUSTER2_NFS_SERVER_USER_DATA_FILE      = "../nfs/files/initial_setup-region2_cluster2.sh"
  CLUSTER2_BROKER_05_USER_DATA_FILE       = "../broker/region1/cluster2/broker5_live3/initial_setup-01.sh"
  CLUSTER2_BROKER_06_USER_DATA_FILE       = "../broker/region1/cluster2/broker6_bak3/initial_setup-01.sh"
  CLUSTER2_BROKER_07_USER_DATA_FILE       = "../broker/region1/cluster2/broker7_live4/initial_setup-01.sh"
  CLUSTER2_BROKER_08_USER_DATA_FILE       = "../broker/region1/cluster2/broker8_bak4/initial_setup-01.sh"
  CLUSTER2_ROUTER_03_SPOKE_USER_DATA_FILE = "../router/spoke-router3/region1-initial_setup-01.sh"

}