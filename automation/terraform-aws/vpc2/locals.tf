locals {
  ROUTER_SECURITY_GROUP_IDS = [
    module.common.vpc_common.security_group_ping_ssh_id,
    module.common.vpc_common.security_group_amq_broker_id,
    module.common.vpc_common.security_group_amq_router_id,
    module.common.vpc_common.security_group_default_id
  ]

  INSTANCE_INFO = {
    (var.KEY_NFS) : {
      suffix : "nfs-server-02", private_ip : "${var.IP_NUMBER_PREFIX.1}.60", main_zone : "2"
    }
    (var.KEY_BROKER_01) : {
      suffix : "broker05-live1", private_ip : "${var.IP_NUMBER_PREFIX.1}.61", main_zone : "2"
    }
    (var.KEY_BROKER_02) : {
      suffix : "broker06-bak1", private_ip : "${var.IP_NUMBER_PREFIX.0}.61", main_zone : "1"
    }
    (var.KEY_BROKER_03) : {
      suffix : "broker07-live2", private_ip : "${var.IP_NUMBER_PREFIX.0}.62", main_zone : "1"
    }
    (var.KEY_BROKER_04) : {
      suffix : "broker08-bak2", private_ip : "${var.IP_NUMBER_PREFIX.1}.62", main_zone : "2"
    }
  }
  
  SPOKE_ROUTER_03_SUFFIX         = "spoke-router3"
  SPOKE_ROUTER_03_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.102"
  SPOKE_ROUTER_03_MAIN_ZONE      = module.common.zone_n_subnet_map["2"].zone
  SPOKE_ROUTER_03_MAIN_SUBNET_ID = module.common.zone_n_subnet_map["2"].subnet
}
