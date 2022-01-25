locals {
  REGION = var.regions_zones_cidrs.dallas.region

  ZONE1 = var.regions_zones_cidrs.dallas.zones.dal1
  ZONE2 = var.regions_zones_cidrs.dallas.zones.dal2
  ZONE3 = var.regions_zones_cidrs.dallas.zones.dal3

  ZONE1_CIDR = var.regions_zones_cidrs.dallas.cidr_block.dal1
  ZONE2_CIDR = var.regions_zones_cidrs.dallas.cidr_block.dal2
  ZONE3_CIDR = var.regions_zones_cidrs.dallas.cidr_block.dal3

  INSTANCE_PROFILE = "bx2-2x8"

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.50"
  NFS_MAIN_ZONE      = local.ZONE1
  NFS_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_09_SUFFIX         = "broker09-live5"
  BROKER_09_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.51"
  BROKER_09_MAIN_ZONE      = local.ZONE1
  BROKER_09_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_10_SUFFIX         = "broker10-bak5"
  BROKER_10_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.51"
  BROKER_10_MAIN_ZONE      = local.ZONE2
  BROKER_10_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_11_SUFFIX         = "broker11-live6"
  BROKER_11_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.51"
  BROKER_11_MAIN_ZONE      = local.ZONE3
  BROKER_11_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  BROKER_12_SUFFIX         = "broker12-bak6"
  BROKER_12_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.52"
  BROKER_12_MAIN_ZONE      = local.ZONE1
  BROKER_12_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  HUB_ROUTER_04_SUFFIX         = "hub-router4"
  HUB_ROUTER_04_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.100"
  HUB_ROUTER_04_MAIN_ZONE      = local.ZONE3
  HUB_ROUTER_04_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  SPOKE_ROUTER_05_SUFFIX         = "spoke-router5"
  SPOKE_ROUTER_05_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.100"
  SPOKE_ROUTER_05_MAIN_ZONE      = local.ZONE2
  SPOKE_ROUTER_05_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  VPC_NAME                        = "${var.PREFIX}-vpc-${local.REGION}-1"
  VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.VPC_NAME}-default-sg"

  SUBNET_PREFIX         = "${var.PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${var.PREFIX}-sec-grp"
}