
output "prefix" {
  value = var.PREFIX
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

output "vpc_cidr" {
  value = module.common.vpc_cidr
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


output "security_group_default_id" {
  value = module.common.security_group_default_id
}

output "security_group_default_name" {
  value = module.common.security_group_default_name
}

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

output "efs_fs_id" {
  value = module.common.efs_fs_id
}

output "efs_fs_dns" {
  value = module.common.efs_fs_dns
}


#
#  NFS server section
#
output "nfs-server-private_ip" {
  value = module.common.nfs-server-private_ip
}

output "nfs-server-public_ip" {
  value = module.common.nfs-server-public_ip
}

output "nfs-server-instance_name" {
  value = module.common.nfs-server-instance_name
}

output "nfs-server-host_id" {
  value = module.common.nfs-server-host_id
}


#
# Broker 01 (live 01) section
#
output "broker01-live-private_ip" {
  value = module.common.broker01-live-private_ip
}

output "broker01-live-public_ip" {
  value = module.common.broker01-live-public_ip
}

output "broker01-live-instance_name" {
  value = module.common.broker01-live-instance_name
}

output "broker01-live-host_id" {
  value = module.common.broker01-live-host_id
}


#
# Broker 02 (bak 01) section
#
output "broker02-bak-private_ip" {
  value = module.common.broker02-bak-private_ip
}

output "broker02-bak-public_ip" {
  value = module.common.broker02-bak-public_ip
}

output "broker02-bak-instance_name" {
  value = module.common.broker02-bak-instance_name
}

output "broker02-bak-host_id" {
  value = module.common.broker02-bak-host_id
}


#
# Broker 03 (live 02) section
#
output "broker03-live-private_ip" {
  value = module.common.broker03-live-private_ip
}

output "broker03-live-public_ip" {
  value = module.common.broker03-live-public_ip
}

output "broker03-live-instance_name" {
  value = module.common.broker03-live-instance_name
}

output "broker03-live-host_id" {
  value = module.common.broker03-live-host_id
}


#
# Broker 04 (bak 02) section
#
output "broker04-bak-private_ip" {
  value = module.common.broker04-bak-private_ip
}

output "broker04-bak-public_ip" {
  value = module.common.broker04-bak-public_ip
}

output "broker04-bak-instance_name" {
  value = module.common.broker04-bak-instance_name
}

output "broker04-bak-host_id" {
  value = module.common.broker04-bak-host_id
}


#
# Router 03 (spoke router) section
#
output "router-03-spoke-private_ip" {
  value = module.router-03-spoke.private_ip
}

output "router-03-spoke-public_ip" {
  value = module.router-03-spoke.public_ip
}

output "router-03-spoke-instance_name" {
  value = module.router-03-spoke.instance_name
}

output "router-03-spoke-host_id" {
  value = module.router-03-spoke.host_id
}
