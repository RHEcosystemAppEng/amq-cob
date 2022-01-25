locals {
  REGION = var.regions_zones_cidrs.toronto.region

  ZONE1 = var.regions_zones_cidrs.toronto.zones.tor1
  ZONE2 = var.regions_zones_cidrs.toronto.zones.tor2
  ZONE3 = var.regions_zones_cidrs.toronto.zones.tor3

  ZONE1_CIDR = var.regions_zones_cidrs.toronto.cidr_block.tor1
  ZONE2_CIDR = var.regions_zones_cidrs.toronto.cidr_block.tor2
  ZONE3_CIDR = var.regions_zones_cidrs.toronto.cidr_block.tor3

  INSTANCE_PROFILE = "bx2-2x8"

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.50"
  NFS_MAIN_ZONE      = local.ZONE1
  NFS_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_01_SUFFIX         = "broker01-live1"
  BROKER_01_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.51"
  BROKER_01_MAIN_ZONE      = local.ZONE1
  BROKER_01_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_02_SUFFIX         = "broker02-bak1"
  BROKER_02_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.51"
  BROKER_02_MAIN_ZONE      = local.ZONE2
  BROKER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_03_SUFFIX         = "broker03-live2"
  BROKER_03_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.51"
  BROKER_03_MAIN_ZONE      = local.ZONE3
  BROKER_03_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  BROKER_04_SUFFIX         = "broker04-bak2"
  BROKER_04_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.52"
  BROKER_04_MAIN_ZONE      = local.ZONE1
  BROKER_04_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  HUB_ROUTER_01_SUFFIX         = "hub-router1"
  HUB_ROUTER_01_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.100"
  HUB_ROUTER_01_MAIN_ZONE      = local.ZONE3
  HUB_ROUTER_01_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  SPOKE_ROUTER_02_SUFFIX         = "spoke-router2"
  SPOKE_ROUTER_02_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.100"
  SPOKE_ROUTER_02_MAIN_ZONE      = local.ZONE2
  SPOKE_ROUTER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  VPC_NAME                        = "${var.PREFIX}-vpc-${local.REGION}-1"
  VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.VPC_NAME}-default-sg"

  SUBNET_PREFIX         = "${var.PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${var.PREFIX}-sec-grp"
}