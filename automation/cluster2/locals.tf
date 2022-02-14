locals {
  REGION = var.REGION

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.60"
  NFS_MAIN_ZONE      = var.ZONE2
  NFS_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_05_SUFFIX         = "broker05-live3"
  BROKER_05_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.61"
  BROKER_05_MAIN_ZONE      = var.ZONE3
  BROKER_05_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  BROKER_06_SUFFIX         = "broker06-bak3"
  BROKER_06_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.61"
  BROKER_06_MAIN_ZONE      = var.ZONE2
  BROKER_06_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_07_SUFFIX         = "broker07-live4"
  BROKER_07_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.61"
  BROKER_07_MAIN_ZONE      = var.ZONE1
  BROKER_07_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_08_SUFFIX         = "broker08-bak4"
  BROKER_08_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.62"
  BROKER_08_MAIN_ZONE      = var.ZONE3
  BROKER_08_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone

  SPOKE_ROUTER_03_SUFFIX         = "spoke-router3"
  SPOKE_ROUTER_03_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.100"
  SPOKE_ROUTER_03_MAIN_ZONE      = var.ZONE1
  SPOKE_ROUTER_03_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  tags = concat(var.tags, [
    "cluster: 2"
  ])
}