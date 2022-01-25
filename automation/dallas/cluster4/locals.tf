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
  NFS_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.60"
  NFS_MAIN_ZONE      = local.ZONE2
  NFS_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_13_SUFFIX         = "broker13-live7"
  BROKER_13_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.61"
  BROKER_13_MAIN_ZONE      = local.ZONE3
  BROKER_13_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  BROKER_14_SUFFIX         = "broker14-bak7"
  BROKER_14_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.61"
  BROKER_14_MAIN_ZONE      = local.ZONE1
  BROKER_14_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_15_SUFFIX         = "broker15-live8"
  BROKER_15_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.61"
  BROKER_15_MAIN_ZONE      = local.ZONE2
  BROKER_15_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_16_SUFFIX         = "broker16-bak8"
  BROKER_16_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.62"
  BROKER_16_MAIN_ZONE      = local.ZONE1
  BROKER_16_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  SPOKE_ROUTER_06_SUFFIX         = "spoke-router6"
  SPOKE_ROUTER_06_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.100"
  SPOKE_ROUTER_06_MAIN_ZONE      = local.ZONE1
  SPOKE_ROUTER_06_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  # VPC is numbered 2 as we already have another VPC with same name and ending in suffix 1
  VPC_NAME                        = "${var.PREFIX}-vpc-${local.REGION}-2"
  VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.VPC_NAME}-default-sg"

  SUBNET_PREFIX         = "${var.PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${var.PREFIX}-sec-grp"
}