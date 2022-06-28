locals {
  REGION = var.REGION

  SEC_GRP_DEFAULT_ID   = module.common.security_group_default_id
  SEC_GRP_PING_SSH_ID   = module.common.security_group_ping_ssh_id
  SEC_GRP_AMQ_BROKER_ID = module.common.security_group_amq_broker_id
  SEC_GRP_AMQ_ROUTER_ID = module.common.security_group_amq_router_id

  BROKER_SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_AMQ_BROKER_ID, local.SEC_GRP_DEFAULT_ID]
  ROUTER_SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_AMQ_BROKER_ID, local.SEC_GRP_AMQ_ROUTER_ID, local.SEC_GRP_DEFAULT_ID]

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.60"
  NFS_MAIN_ZONE      = module.common.zone2
  NFS_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_01_SUFFIX         = "broker05-live1"
  BROKER_01_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.61"
  BROKER_01_MAIN_ZONE      = module.common.zone2
  BROKER_01_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_02_SUFFIX         = "broker06-bak1"
  BROKER_02_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.61"
  BROKER_02_MAIN_ZONE      = module.common.zone1
  BROKER_02_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_03_SUFFIX         = "broker07-live2"
  BROKER_03_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.62"
  BROKER_03_MAIN_ZONE      = module.common.zone1
  BROKER_03_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_04_SUFFIX         = "broker08-bak2"
  BROKER_04_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.62"
  BROKER_04_MAIN_ZONE      = module.common.zone2
  BROKER_04_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  SPOKE_ROUTER_03_SUFFIX         = "spoke-router3"
  SPOKE_ROUTER_03_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.102"
  SPOKE_ROUTER_03_MAIN_ZONE      = module.common.zone2
  SPOKE_ROUTER_03_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  tags = merge(
    var.TAGS,
    {
      Cluster : "cluster: 2"
    }
  )
}
