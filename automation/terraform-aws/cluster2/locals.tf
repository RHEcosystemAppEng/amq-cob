locals {
  ROUTER_SECURITY_GROUP_IDS = [
    module.common.security_group_ping_ssh_id,
    module.common.security_group_amq_broker_id,
    module.common.security_group_amq_router_id, module.common.security_group_default_id
  ]

  SPOKE_ROUTER_03_SUFFIX         = var.INSTANCE_INFO[var.KEY_ROUTER_03].suffix
  SPOKE_ROUTER_03_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_ROUTER_03].private_ip
  SPOKE_ROUTER_03_MAIN_ZONE      = module.common.zone_n_subnet_map[var.INSTANCE_INFO[var.KEY_ROUTER_03].main_zone].zone
  SPOKE_ROUTER_03_MAIN_SUBNET_ID = module.common.zone_n_subnet_map[var.INSTANCE_INFO[var.KEY_ROUTER_03].main_zone].subnet
}
