output "key" {
  value = var.ibmcloud_api_key
}

output "prefix" {
  value = var.PREFIX
}

output "instance_profile" {
  value = local.INSTANCE_PROFILE
}

output "region" {
  value = local.REGION
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

output "default_vpc_sg" {
  value = module.common.default_vpc_sg
}

output "custom_security_group_1_id" {
  value = module.common.custom_sg_1_id
}

output "custom_security_group_1_name" {
  value = module.common.custom_sg_1_name
}

output "custom_security_group_2_id" {
  value = module.common.custom_sg_2_id
}

output "custom_security_group_2_name" {
  value = module.common.custom_sg_2_name
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

output "nfs-server-floating_ip_name" {
  value = module.nfs-server.floating_ip_name
}


#
# Broker 05 (live 03) section
#
output "broker05-live-private_ip" {
  value = module.broker-05-live.private_ip
}

output "broker05-live-public_ip" {
  value = module.broker-05-live.public_ip
}

output "broker05-live-instance_name" {
  value = module.broker-05-live.instance_name
}

output "broker05-live-floating_ip_name" {
  value = module.broker-05-live.floating_ip_name
}


#
# Broker 06 (bak 03) section
#
output "broker06-bak-private_ip" {
  value = module.broker-06-bak.private_ip
}

output "broker06-bak-public_ip" {
  value = module.broker-06-bak.public_ip
}

output "broker06-bak-instance_name" {
  value = module.broker-06-bak.instance_name
}

output "broker06-bak-floating_ip_name" {
  value = module.broker-06-bak.floating_ip_name
}


#
# Broker 07 (live 04) section
#
output "broker07-live-private_ip" {
  value = module.broker-07-live.private_ip
}

output "broker07-live-public_ip" {
  value = module.broker-07-live.public_ip
}

output "broker07-live-instance_name" {
  value = module.broker-07-live.instance_name
}

output "broker07-live-floating_ip_name" {
  value = module.broker-07-live.floating_ip_name
}


#
# Broker 08 (bak 04) section
#
output "broker08-bak-private_ip" {
  value = module.broker-08-bak.private_ip
}

output "broker08-bak-public_ip" {
  value = module.broker-08-bak.public_ip
}

output "broker08-bak-instance_name" {
  value = module.broker-08-bak.instance_name
}

output "broker08-bak-floating_ip_name" {
  value = module.broker-08-bak.floating_ip_name
}


#
# Router - common section
#
output "custom_security_group_3_id" {
  value = module.router_common.custom_sg_3_id
}

output "custom_security_group_3_name" {
  value = module.router_common.custom_sg_3_name
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

output "router-03-spoke-floating_ip_name" {
  value = module.router-03-spoke.floating_ip_name
}
