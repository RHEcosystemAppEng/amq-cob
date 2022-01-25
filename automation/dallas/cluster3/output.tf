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
# Broker 09 (live 05) section
#
output "broker09-live-private_ip" {
  value = module.broker-09-live.private_ip
}

output "broker09-live-public_ip" {
  value = module.broker-09-live.public_ip
}

output "broker09-live-instance_name" {
  value = module.broker-09-live.instance_name
}

output "broker09-live-floating_ip_name" {
  value = module.broker-09-live.floating_ip_name
}


#
# Broker 10 (bak 05) section
#
output "broker10-bak-private_ip" {
  value = module.broker-10-bak.private_ip
}

output "broker10-bak-public_ip" {
  value = module.broker-10-bak.public_ip
}

output "broker10-bak-instance_name" {
  value = module.broker-10-bak.instance_name
}

output "broker10-bak-floating_ip_name" {
  value = module.broker-10-bak.floating_ip_name
}


#
# Broker 11 (live 06) section
#
output "broker11-live-private_ip" {
  value = module.broker-11-live.private_ip
}

output "broker11-live-public_ip" {
  value = module.broker-11-live.public_ip
}

output "broker11-live-instance_name" {
  value = module.broker-11-live.instance_name
}

output "broker11-live-floating_ip_name" {
  value = module.broker-11-live.floating_ip_name
}


#
# Broker 12 (bak 06) section
#
output "broker12-bak-private_ip" {
  value = module.broker-12-bak.private_ip
}

output "broker12-bak-public_ip" {
  value = module.broker-12-bak.public_ip
}

output "broker12-bak-instance_name" {
  value = module.broker-12-bak.instance_name
}

output "broker12-bak-floating_ip_name" {
  value = module.broker-12-bak.floating_ip_name
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
# Router 04 (hub router) section
#
output "router-04-hub-private_ip" {
  value = module.router-04-hub.private_ip
}

output "router-04-hub-public_ip" {
  value = module.router-04-hub.public_ip
}

output "router-04-hub-instance_name" {
  value = module.router-04-hub.instance_name
}

output "router-04-hub-floating_ip_name" {
  value = module.router-04-hub.floating_ip_name
}


#
# Router 05 (spoke router) section
#
output "router-05-spoke-private_ip" {
  value = module.router-05-spoke.private_ip
}

output "router-05-spoke-public_ip" {
  value = module.router-05-spoke.public_ip
}

output "router-05-spoke-instance_name" {
  value = module.router-05-spoke.instance_name
}

output "router-05-spoke-floating_ip_name" {
  value = module.router-05-spoke.floating_ip_name
}
