locals {
  ROUTER_SECURITY_GROUP_IDS = [
    module.common.vpc_common.security_group_ping_ssh_id,
    module.common.vpc_common.security_group_amq_broker_id,
    module.common.vpc_common.security_group_amq_router_id,
    module.common.vpc_common.security_group_default_id
  ]

  INSTANCE_INFO = {
    (var.KEY_NFS) : {
      suffix : "nfs-server-01", private_ip : "${var.IP_NUMBER_PREFIX.0}.50", main_zone : "1"
    }
    (var.KEY_BROKER_01) : {
      suffix : "broker01-live1", private_ip : "${var.IP_NUMBER_PREFIX.0}.51", main_zone : "1"
    }
    (var.KEY_BROKER_02) : {
      suffix : "broker02-bak1", private_ip : "${var.IP_NUMBER_PREFIX.1}.51", main_zone : "2"
    }
    (var.KEY_BROKER_03) : {
      suffix : "broker03-live2", private_ip : "${var.IP_NUMBER_PREFIX.1}.52", main_zone : "2"
    }
    (var.KEY_BROKER_04) : {
      suffix : "broker04-bak2", private_ip : "${var.IP_NUMBER_PREFIX.0}.52", main_zone : "1"
    }
  }

  HUB_ROUTER_01_SUFFIX         = "hub-router1"
  HUB_ROUTER_01_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.100"
  HUB_ROUTER_01_MAIN_ZONE      = module.common.zone_n_subnet_map["2"].zone
  HUB_ROUTER_01_MAIN_SUBNET_ID = module.common.zone_n_subnet_map["2"].subnet

  SPOKE_ROUTER_02_SUFFIX         = "spoke-router2"
  SPOKE_ROUTER_02_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.101"
  SPOKE_ROUTER_02_MAIN_ZONE      = module.common.zone_n_subnet_map["1"].zone
  SPOKE_ROUTER_02_MAIN_SUBNET_ID = module.common.zone_n_subnet_map["1"].subnet
}
