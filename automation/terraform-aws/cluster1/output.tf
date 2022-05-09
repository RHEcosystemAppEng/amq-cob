
output "prefix" {
  value = var.PREFIX
}

output "region" {
  value = local.REGION
}

output "ami_id" {
  value = var.AMI_ID
}

output "ami_name" {
  value = var.AMI_NAME
}

output "zone1" {
  value = module.common.zone1
}

output "zone2" {
  value = module.common.zone2
}

output "zone3" {
  value = module.common.zone3
}

output "zone1_cidr" {
  value = module.common.zone1_cidr
}

output "zone2_cidr" {
  value = module.common.zone2_cidr
}

output "zone3_cidr" {
  value = module.common.zone3_cidr
}

output "route_table-main-id" {
  value = module.common.route_table-main-id
}

output "route_table-default-id" {
  value = module.common.route_table-default-id
}


#output "default_vpc_sg" {
#  value = module.common.default_vpc_sg
#}

output "security_group_ping_ssh_id" {
  value = module.common.security_group_ping_ssh_id
}

output "security_group_ping_ssh_name" {
  value = module.common.security_group_ping_ssh_name
}

output "security_group_amq_broker_id" {
  value = module.common.security_group_amq_broker_id
}

output "security_group_amq_broker_name" {
  value = module.common.security_group_amq_broker_name
}

output "security_group_amq_router_id" {
  value = module.common.security_group_amq_router_id
}

output "security_group_amq_router_name" {
  value = module.common.security_group_amq_router_name
}

output "vpc" {
  value = module.common.vpc
}

output "vpc_id" {
  value = module.common.vpc_id
}

output "vpc_name" {
  value = module.common.vpc_name
}

#
#  NFS server section
#
output "nfs-server-private_ip" {
  value = module.nfs-server.private_ip
}

output "nfs-server-public_ip" {
  value = module.nfs-server.public_ip
}

output "nfs-server-instance_name" {
  value = module.nfs-server.instance_name
}

output "nfs-server-host_id" {
  value = module.nfs-server.host_id
}




#
# Broker 01 (live 01) section
#
output "broker01-live-private_ip" {
  value = module.broker-01-live.private_ip
}

output "broker01-live-public_ip" {
  value = module.broker-01-live.public_ip
}

output "broker01-live-instance_name" {
  value = module.broker-01-live.instance_name
}

output "broker01-live-host_id" {
  value = module.broker-01-live.host_id
}


#
# Broker 02 (bak 01) section
#
output "broker02-bak-private_ip" {
  value = module.broker-02-bak.private_ip
}

output "broker02-bak-public_ip" {
  value = module.broker-02-bak.public_ip
}

output "broker02-bak-instance_name" {
  value = module.broker-02-bak.instance_name
}

output "broker02-bak-host_id" {
  value = module.broker-02-bak.host_id
}


#
# Broker 03 (live 02) section
#
output "broker03-live-private_ip" {
  value = module.broker-03-live.private_ip
}

output "broker03-live-public_ip" {
  value = module.broker-03-live.public_ip
}

output "broker03-live-instance_name" {
  value = module.broker-03-live.instance_name
}

output "broker03-live-host_id" {
  value = module.broker-03-live.host_id
}


#
# Broker 04 (bak 02) section
#
output "broker04-bak-private_ip" {
  value = module.broker-04-bak.private_ip
}

output "broker04-bak-public_ip" {
  value = module.broker-04-bak.public_ip
}

output "broker04-bak-instance_name" {
  value = module.broker-04-bak.instance_name
}

output "broker04-bak-host_id" {
  value = module.broker-04-bak.host_id
}

#
##
## Router - common section
##
#output "custom_security_group_3_id" {
#  value = module.router-common.custom_sg_3_id
#}
#
#output "custom_security_group_3_name" {
#  value = module.router-common.custom_sg_3_name
#}
#

#
# Router 01 (hub router) section
#
output "router-01-hub-private_ip" {
  value = module.router-01-hub.private_ip
}

output "router-01-hub-public_ip" {
  value = module.router-01-hub.public_ip
}

output "router-01-hub-instance_name" {
  value = module.router-01-hub.instance_name
}

output "router-01-hub-host_id" {
  value = module.router-01-hub.host_id
}


#
# Router 02 (spoke router) section
#
output "router-02-spoke-private_ip" {
  value = module.router-02-spoke.private_ip
}

output "router-02-spoke-public_ip" {
  value = module.router-02-spoke.public_ip
}

output "router-02-spoke-instance_name" {
  value = module.router-02-spoke.instance_name
}

output "router-02-spoke-host_id" {
  value = module.router-02-spoke.host_id
}
