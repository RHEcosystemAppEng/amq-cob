locals {
  ROUTER_SECURITY_GROUP_IDS = [
    module.common.security_group_ping_ssh_id,
    module.common.security_group_amq_broker_id,
    module.common.security_group_amq_router_id,
    module.common.security_group_default_id
  ]

  HUB_ROUTER_01_SUFFIX         = var.INSTANCE_INFO["router_01"].suffix
  HUB_ROUTER_01_PRIVATE_IP     = var.INSTANCE_INFO["router_01"].private_ip
  HUB_ROUTER_01_MAIN_ZONE      = module.common.zone_n_subnet_map[var.INSTANCE_INFO["router_01"].main_zone].zone
  HUB_ROUTER_01_MAIN_SUBNET_ID = module.common.zone_n_subnet_map[var.INSTANCE_INFO["router_01"].main_zone].subnet

  SPOKE_ROUTER_02_SUFFIX         = var.INSTANCE_INFO["router_02"].suffix
  SPOKE_ROUTER_02_PRIVATE_IP     = var.INSTANCE_INFO["router_02"].private_ip
  SPOKE_ROUTER_02_MAIN_ZONE      = module.common.zone_n_subnet_map[var.INSTANCE_INFO["router_02"].main_zone].zone
  SPOKE_ROUTER_02_MAIN_SUBNET_ID = module.common.zone_n_subnet_map[var.INSTANCE_INFO["router_02"].main_zone].subnet
}
