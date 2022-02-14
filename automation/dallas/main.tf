module "dallas-cluster1" {
  source = "../cluster1"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = var.ssh_key
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER1_PRIVATE_IP_PREFIX

  SECURITY_GROUP_PREFIX = local.SECURITY_GROUP_PREFIX
  SUBNET_PREFIX         = local.SUBNET_PREFIX

  REGION     = var.REGION
  ZONE1      = local.ZONE1
  ZONE1_CIDR = local.CLUSTER1_ZONE1_CIDR
  ZONE2      = local.ZONE2
  ZONE2_CIDR = local.CLUSTER1_ZONE2_CIDR
  ZONE3      = local.ZONE3
  ZONE3_CIDR = local.CLUSTER1_ZONE3_CIDR
  VPC_NAME   = local.CLUSTER1_VPC_NAME

  NFS_SERVER_USER_DATA_FILE      = local.CLUSTER1_NFS_SERVER_USER_DATA_FILE
  BROKER_01_USER_DATA_FILE       = local.CLUSTER1_BROKER_01_USER_DATA_FILE
  BROKER_02_USER_DATA_FILE       = local.CLUSTER1_BROKER_02_USER_DATA_FILE
  BROKER_03_USER_DATA_FILE       = local.CLUSTER1_BROKER_03_USER_DATA_FILE
  BROKER_04_USER_DATA_FILE       = local.CLUSTER1_BROKER_04_USER_DATA_FILE
  ROUTER_01_HUB_USER_DATA_FILE   = local.CLUSTER1_ROUTER_01_HUB_USER_DATA_FILE
  ROUTER_02_SPOKE_USER_DATA_FILE = local.CLUSTER1_ROUTER_02_SPOKE_USER_DATA_FILE

  tags = var.tags
}

module "dallas-cluster2" {
  source = "../cluster2"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = var.ssh_key
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER2_PRIVATE_IP_PREFIX

  SECURITY_GROUP_PREFIX = local.SECURITY_GROUP_PREFIX
  SUBNET_PREFIX         = local.SUBNET_PREFIX

  REGION     = var.REGION
  ZONE1      = local.ZONE1
  ZONE1_CIDR = local.CLUSTER2_ZONE1_CIDR
  ZONE2      = local.ZONE2
  ZONE2_CIDR = local.CLUSTER2_ZONE2_CIDR
  ZONE3      = local.ZONE3
  ZONE3_CIDR = local.CLUSTER2_ZONE3_CIDR
  VPC_NAME   = local.CLUSTER2_VPC_NAME

  NFS_SERVER_USER_DATA_FILE      = local.CLUSTER2_NFS_SERVER_USER_DATA_FILE
  BROKER_05_USER_DATA_FILE       = local.CLUSTER2_BROKER_05_USER_DATA_FILE
  BROKER_06_USER_DATA_FILE       = local.CLUSTER2_BROKER_06_USER_DATA_FILE
  BROKER_07_USER_DATA_FILE       = local.CLUSTER2_BROKER_07_USER_DATA_FILE
  BROKER_08_USER_DATA_FILE       = local.CLUSTER2_BROKER_08_USER_DATA_FILE
  ROUTER_03_SPOKE_USER_DATA_FILE = local.CLUSTER2_ROUTER_03_SPOKE_USER_DATA_FILE

  tags = var.tags
}


module "transit-gateway-local-dallas" {
  source = "../transit-gateway/common"

  ibmcloud_api_key = var.ibmcloud_api_key

  GATEWAY_NAME   = "${var.PREFIX}-${var.REGION}-local-01"
  GATEWAY_REGION = var.REGION
  NETWORK_TYPE   = "vpc"
  GLOBAL         = false

  VPC_1 = module.dallas-cluster1.vpc
  VPC_2 = module.dallas-cluster2.vpc

  tags = var.tags
}
