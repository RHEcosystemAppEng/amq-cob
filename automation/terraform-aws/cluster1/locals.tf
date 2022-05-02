locals {
  REGION = var.REGION

  SEC_GRP_1_ID = module.common.custom_sg_1_id
  SEC_GRP_2_ID = module.common.custom_sg_2_id
  SEC_GRP_3_ID = module.common.custom_sg_3_id

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.50"
  NFS_MAIN_ZONE      = module.common.zone1
  NFS_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

#  BROKER_01_SUFFIX         = "broker01-live1"
#  BROKER_01_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.51"
#  BROKER_01_MAIN_ZONE      = var.ZONE1
#  BROKER_01_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone
#
#  BROKER_02_SUFFIX         = "broker02-bak1"
#  BROKER_02_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.51"
#  BROKER_02_MAIN_ZONE      = var.ZONE2
#  BROKER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone
#
#  BROKER_03_SUFFIX         = "broker03-live2"
#  BROKER_03_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.51"
#  BROKER_03_MAIN_ZONE      = var.ZONE3
#  BROKER_03_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone
#
#  BROKER_04_SUFFIX         = "broker04-bak2"
#  BROKER_04_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.0.52"
#  BROKER_04_MAIN_ZONE      = var.ZONE1
#  BROKER_04_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone
#
#  HUB_ROUTER_01_SUFFIX         = "hub-router1"
#  HUB_ROUTER_01_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.128.100"
#  HUB_ROUTER_01_MAIN_ZONE      = var.ZONE3
#  HUB_ROUTER_01_MAIN_SUBNET_ID = module.common.subnet_3_id # Subnet should match zone
#
#  SPOKE_ROUTER_02_SUFFIX         = "spoke-router2"
#  SPOKE_ROUTER_02_PRIVATE_IP     = "${var.PRIVATE_IP_PREFIX}.64.100"
#  SPOKE_ROUTER_02_MAIN_ZONE      = var.ZONE2
#  SPOKE_ROUTER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  tags = merge(
    var.TAGS,
    {
      Cluster: "cluster: 1"
    }
  )
}
