output "key" {
  value = var.ibmcloud_api_key
}

output "region" {
  value = var.REGION
}

output "zone1" {
  value = module.toronto-cluster1.zone1
}

output "zone2" {
  value = module.toronto-cluster1.zone2
}

output "zone3" {
  value = module.toronto-cluster1.zone3
}

output "vpc1-zone1_cidr" {
  value = module.toronto-cluster1.zone1_cidr
}

output "vpc1-zone2_cidr" {
  value = module.toronto-cluster1.zone2_cidr
}

output "vpc1-zone3_cidr" {
  value = module.toronto-cluster1.zone3_cidr
}

output "vpc1-default_vpc_sg" {
  value = module.toronto-cluster1.default_vpc_sg
}

output "vpc1-custom_security_group_1_id" {
  value = module.toronto-cluster1.custom_security_group_1_id
}

output "vpc1-custom_security_group_1_name" {
  value = module.toronto-cluster1.custom_security_group_1_name
}

output "vpc1-custom_security_group_2_id" {
  value = module.toronto-cluster1.custom_security_group_2_id
}

output "vpc1-custom_security_group_2_name" {
  value = module.toronto-cluster1.custom_security_group_2_name
}

output "vpc1-custom_security_group_3_id" {
  value = module.toronto-cluster1.custom_security_group_3_id
}

output "vpc1-custom_security_group_3_name" {
  value = module.toronto-cluster1.custom_security_group_3_name
}

output "vpc1-vpc_id" {
  value = module.toronto-cluster1.vpc_id
}

output "vpc1-vpc_name" {
  value = module.toronto-cluster1.vpc_name
}

#
#  NFS server section - cluster1
#
output "vpc1-nfs-server-private_ip" {
  value = module.toronto-cluster1.nfs-server-private_ip
}

output "vpc1-nfs-server-public_ip" {
  value = module.toronto-cluster1.nfs-server-public_ip
}

output "vpc1-nfs-server-instance_name" {
  value = module.toronto-cluster1.nfs-server-instance_name
}

output "vpc1-nfs-server-floating_ip_name" {
  value = module.toronto-cluster1.nfs-server-floating_ip_name
}


#
# Broker 01 (live 01) section
#
output "vpc1-broker01-live-private_ip" {
  value = module.toronto-cluster1.broker01-live-private_ip
}

output "vpc1-broker01-live-public_ip" {
  value = module.toronto-cluster1.broker01-live-public_ip
}

output "vpc1-broker01-live-instance_name" {
  value = module.toronto-cluster1.broker01-live-instance_name
}

output "vpc1-broker01-live-floating_ip_name" {
  value = module.toronto-cluster1.broker01-live-floating_ip_name
}


#
# Broker 02 (bak 01) section
#
output "vpc1-broker02-bak-private_ip" {
  value = module.toronto-cluster1.broker02-bak-private_ip
}

output "vpc1-broker02-bak-public_ip" {
  value = module.toronto-cluster1.broker02-bak-public_ip
}

output "vpc1-broker02-bak-instance_name" {
  value = module.toronto-cluster1.broker02-bak-instance_name
}

output "vpc1-broker02-bak-floating_ip_name" {
  value = module.toronto-cluster1.broker02-bak-floating_ip_name
}


#
# Broker 03 (live 02) section
#
output "vpc1-broker03-live-private_ip" {
  value = module.toronto-cluster1.broker03-live-private_ip
}

output "vpc1-broker03-live-public_ip" {
  value = module.toronto-cluster1.broker03-live-public_ip
}

output "vpc1-broker03-live-instance_name" {
  value = module.toronto-cluster1.broker03-live-instance_name
}

output "vpc1-broker03-live-floating_ip_name" {
  value = module.toronto-cluster1.broker03-live-floating_ip_name
}


#
# Broker 04 (bak 02) section
#
output "vpc1-broker04-bak-private_ip" {
  value = module.toronto-cluster1.broker04-bak-private_ip
}

output "vpc1-broker04-bak-public_ip" {
  value = module.toronto-cluster1.broker04-bak-public_ip
}

output "vpc1-broker04-bak-instance_name" {
  value = module.toronto-cluster1.broker04-bak-instance_name
}

output "vpc1-broker04-bak-floating_ip_name" {
  value = module.toronto-cluster1.broker04-bak-floating_ip_name
}


#
# Router 01 (hub router) section
#
output "vpc1-router01-hub-private_ip" {
  value = module.toronto-cluster1.router-01-hub-private_ip
}

output "vpc1-router01-hub-public_ip" {
  value = module.toronto-cluster1.router-01-hub-public_ip
}

output "vpc1-router01-hub-instance_name" {
  value = module.toronto-cluster1.router-01-hub-instance_name
}

output "vpc1-router01-hub-floating_ip_name" {
  value = module.toronto-cluster1.router-01-hub-floating_ip_name
}


#
# Router 02 (spoke router) section
#
output "vpc1-router02-spoke-private_ip" {
  value = module.toronto-cluster1.router-02-spoke-private_ip
}

output "vpc1-router02-spoke-public_ip" {
  value = module.toronto-cluster1.router-02-spoke-public_ip
}

output "vpc1-router02-spoke-instance_name" {
  value = module.toronto-cluster1.router-02-spoke-instance_name
}

output "vpc1-router02-spoke-floating_ip_name" {
  value = module.toronto-cluster1.router-02-spoke-floating_ip_name
}
