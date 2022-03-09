module "toronto-cluster1" {
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

  ROUTER_01_HUB_USER_DATA_FILE   = local.CLUSTER1_ROUTER_01_HUB_USER_DATA_FILE
  ROUTER_02_SPOKE_USER_DATA_FILE = local.CLUSTER1_ROUTER_02_SPOKE_USER_DATA_FILE

  tags = var.tags
}

#module "toronto-cluster2" {
#  source = "../cluster2"
#
#  ibmcloud_api_key = var.ibmcloud_api_key
#  ssh_key          = var.ssh_key
#  INSTANCE_PROFILE = local.INSTANCE_PROFILE
#
#  PREFIX            = var.PREFIX
#  PRIVATE_IP_PREFIX = var.CLUSTER2_PRIVATE_IP_PREFIX
#
#  SECURITY_GROUP_PREFIX = local.SECURITY_GROUP_PREFIX
#  SUBNET_PREFIX         = local.SUBNET_PREFIX
#
#  REGION     = var.REGION
#  ZONE1      = local.ZONE1
#  ZONE1_CIDR = local.CLUSTER2_ZONE1_CIDR
#  ZONE2      = local.ZONE2
#  ZONE2_CIDR = local.CLUSTER2_ZONE2_CIDR
#  ZONE3      = local.ZONE3
#  ZONE3_CIDR = local.CLUSTER2_ZONE3_CIDR
#  VPC_NAME   = local.CLUSTER2_VPC_NAME
#
#  ROUTER_03_SPOKE_USER_DATA_FILE = local.CLUSTER2_ROUTER_03_SPOKE_USER_DATA_FILE
#
#  tags = var.tags
#}
#
#
#module "transit-gateway-local-toronto" {
#  source = "../transit-gateway/common"
#
#  ibmcloud_api_key = var.ibmcloud_api_key
#
#  GATEWAY_NAME   = "${var.PREFIX}-${var.REGION}-local-01"
#  GATEWAY_REGION = var.REGION
#  NETWORK_TYPE   = "vpc"
#  GLOBAL         = false
#
#  VPC_1 = module.toronto-cluster1.vpc
#  VPC_2 = module.toronto-cluster2.vpc
#
#  tags = var.tags
#}
