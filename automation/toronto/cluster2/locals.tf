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
  NFS_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.60"
  NFS_MAIN_ZONE      = local.ZONE2
  NFS_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_05_SUFFIX         = "broker05-live3"
  BROKER_05_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.61"
  BROKER_05_MAIN_ZONE      = local.ZONE3
  BROKER_05_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  BROKER_06_SUFFIX         = "broker06-bak3"
  BROKER_06_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.61"
  BROKER_06_MAIN_ZONE      = local.ZONE2
  BROKER_06_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_07_SUFFIX         = "broker07-live4"
  BROKER_07_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.61"
  BROKER_07_MAIN_ZONE      = local.ZONE1
  BROKER_07_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_08_SUFFIX         = "broker08-bak4"
  BROKER_08_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.62"
  BROKER_08_MAIN_ZONE      = local.ZONE3
  BROKER_08_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  SPOKE_ROUTER_03_SUFFIX         = "spoke-router3"
  SPOKE_ROUTER_03_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.100"
  SPOKE_ROUTER_03_MAIN_ZONE      = local.ZONE1
  SPOKE_ROUTER_03_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  # VPC is numbered 2 as we already have another VPC with same name and ending in suffix 1
  VPC_NAME                        = "${var.PREFIX}-vpc-${local.REGION}-2"
  VPC_DEFAULT_SECURITY_GROUP_NAME = "${local.VPC_NAME}-default-sg"

  SUBNET_PREFIX         = "${var.PREFIX}-subnet"
  SECURITY_GROUP_PREFIX = "${var.PREFIX}-sec-grp"
}