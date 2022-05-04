output "key" {
  value = var.SSH_KEY
}

output "region" {
  value = var.REGION
}
output "ami_id" {
  value = module.toronto-cluster1.ami_id
}

output "ami_name" {
  value = module.toronto-cluster1.ami_name
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

output "route_table-main-id" {
  value = module.toronto-cluster1.route_table-main-id

}

output "route_table-default-id" {
  value = module.toronto-cluster1.route_table-default-id
}

#output "vpc1-default_vpc_sg" {
#  value = module.toronto-cluster1.default_vpc_sg
#}

output "vpc1-security_group-ping_ssh-id" {
  value = module.toronto-cluster1.security_group_ping_ssh_id
}

output "vpc1-security_group-ping_ssh-name" {
  value = module.toronto-cluster1.security_group_ping_ssh_name
}

output "vpc1-security_group-amq_broker-id" {
  value = module.toronto-cluster1.security_group_amq_broker_id
}

output "vpc1-security_group-amq_broker-name" {
  value = module.toronto-cluster1.security_group_amq_broker_name
}

output "vpc1-security_group-amq_router-id" {
  value = module.toronto-cluster1.security_group_amq_router_id
}

output "vpc1-security_group-amq_router-name" {
  value = module.toronto-cluster1.security_group_amq_router_name
}

output "vpc1-vpc_id" {
  value = module.toronto-cluster1.vpc_id
}

output "vpc1-vpc_name" {
  value = module.toronto-cluster1.vpc_name
}

#output "vpc2-zone1_cidr" {
#  value = module.toronto-cluster2.zone1_cidr
#}
#
#output "vpc2-zone2_cidr" {
#  value = module.toronto-cluster2.zone2_cidr
#}
#
#output "vpc2-zone3_cidr" {
#  value = module.toronto-cluster2.zone3_cidr
#}
#
#output "vpc2-default_vpc_sg" {
#  value = module.toronto-cluster2.default_vpc_sg
#}
#
#output "vpc2-custom_security_group_1_id" {
#  value = module.toronto-cluster2.custom_security_group_1_id
#}
#
#output "vpc2-custom_security_group_1_name" {
#  value = module.toronto-cluster2.custom_security_group_1_name
#}
#
#output "vpc2-custom_security_group_2_id" {
#  value = module.toronto-cluster2.custom_security_group_2_id
#}
#
#output "vpc2-custom_security_group_2_name" {
#  value = module.toronto-cluster2.custom_security_group_2_name
#}
#
#output "vpc2-custom_security_group_3_id" {
#  value = module.toronto-cluster2.custom_security_group_3_id
#}
#
#output "vpc2-custom_security_group_3_name" {
#  value = module.toronto-cluster2.custom_security_group_3_name
#}
#
#output "vpc2-vpc_id" {
#  value = module.toronto-cluster2.vpc_id
#}
#
#output "vpc2-vpc_name" {
#  value = module.toronto-cluster2.vpc_name
#}

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

output "vpc1-nfs-server-host_id" {
  value = module.toronto-cluster1.nfs-server-host_id
}

##
##  NFS server section - cluster2
##
#output "vpc2-nfs-server-private_ip" {
#  value = module.toronto-cluster2.nfs-server-private_ip
#}
#
#output "vpc2-nfs-server-public_ip" {
#  value = module.toronto-cluster2.nfs-server-public_ip
#}
#
#output "vpc2-nfs-server-instance_name" {
#  value = module.toronto-cluster2.nfs-server-instance_name
#}
#
#output "vpc2-nfs-server-floating_ip_name" {
#  value = module.toronto-cluster2.nfs-server-floating_ip_name
#}
#

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

output "vpc1-broker01-live-host_id" {
  value = module.toronto-cluster1.broker01-live-host_id
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

output "vpc1-broker02-bak-host_id" {
  value = module.toronto-cluster1.broker02-bak-host_id
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

output "vpc1-broker03-live-host_id" {
  value = module.toronto-cluster1.broker03-live-host_id
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

output "vpc1-broker04-bak-host_id" {
  value = module.toronto-cluster1.broker04-bak-host_id
}

##
## Broker 05 (live 03) section
##
#output "vpc2-broker05-live-private_ip" {
#  value = module.toronto-cluster2.broker05-live-private_ip
#}
#
#output "vpc2-broker05-live-public_ip" {
#  value = module.toronto-cluster2.broker05-live-public_ip
#}
#
#output "vpc2-broker05-live-instance_name" {
#  value = module.toronto-cluster2.broker05-live-instance_name
#}
#
#output "vpc2-broker05-live-floating_ip_name" {
#  value = module.toronto-cluster2.broker05-live-floating_ip_name
#}
#
#
##
## Broker 06 (bak 03) section
##
#output "vpc2-broker06-bak-private_ip" {
#  value = module.toronto-cluster2.broker06-bak-private_ip
#}
#
#output "vpc2-broker06-bak-public_ip" {
#  value = module.toronto-cluster2.broker06-bak-public_ip
#}
#
#output "vpc2-broker06-bak-instance_name" {
#  value = module.toronto-cluster2.broker06-bak-instance_name
#}
#
#output "vpc2-broker06-bak-floating_ip_name" {
#  value = module.toronto-cluster2.broker06-bak-floating_ip_name
#}
#
#
##
## Broker 07 (live 04) section
##
#output "vpc2-broker07-live-private_ip" {
#  value = module.toronto-cluster2.broker07-live-private_ip
#}
#
#output "vpc2-broker07-live-public_ip" {
#  value = module.toronto-cluster2.broker07-live-public_ip
#}
#
#output "vpc2-broker07-live-instance_name" {
#  value = module.toronto-cluster2.broker07-live-instance_name
#}
#
#output "vpc2-broker07-live-floating_ip_name" {
#  value = module.toronto-cluster2.broker07-live-floating_ip_name
#}
#
#
##
## Broker 08 (bak 04) section
##
#output "vpc2-broker08-bak-private_ip" {
#  value = module.toronto-cluster2.broker08-bak-private_ip
#}
#
#output "vpc2-broker08-bak-public_ip" {
#  value = module.toronto-cluster2.broker08-bak-public_ip
#}
#
#output "vpc2-broker08-bak-instance_name" {
#  value = module.toronto-cluster2.broker08-bak-instance_name
#}
#
#output "vpc2-broker08-bak-floating_ip_name" {
#  value = module.toronto-cluster2.broker08-bak-floating_ip_name
#}
#
#
##
## Router 01 (hub router) section
##
#output "vpc1-router01-hub-private_ip" {
#  value = module.toronto-cluster1.router-01-hub-private_ip
#}
#
#output "vpc1-router01-hub-public_ip" {
#  value = module.toronto-cluster1.router-01-hub-public_ip
#}
#
#output "vpc1-router01-hub-instance_name" {
#  value = module.toronto-cluster1.router-01-hub-instance_name
#}
#
#output "vpc1-router01-hub-floating_ip_name" {
#  value = module.toronto-cluster1.router-01-hub-floating_ip_name
#}
#
#
##
## Router 02 (spoke router) section
##
#output "vpc1-router02-spoke-private_ip" {
#  value = module.toronto-cluster1.router-02-spoke-private_ip
#}
#
#output "vpc1-router02-spoke-public_ip" {
#  value = module.toronto-cluster1.router-02-spoke-public_ip
#}
#
#output "vpc1-router02-spoke-instance_name" {
#  value = module.toronto-cluster1.router-02-spoke-instance_name
#}
#
#output "vpc1-router02-spoke-floating_ip_name" {
#  value = module.toronto-cluster1.router-02-spoke-floating_ip_name
#}
#
#
##
## Router 03 (spoke router) section
##
#output "vpc2-router03-spoke-private_ip" {
#  value = module.toronto-cluster2.router-03-spoke-private_ip
#}
#
#output "vpc2-router03-spoke-public_ip" {
#  value = module.toronto-cluster2.router-03-spoke-public_ip
#}
#
#output "vpc2-router03-spoke-instance_name" {
#  value = module.toronto-cluster2.router-03-spoke-instance_name
#}
#
#output "vpc2-router03-spoke-floating_ip_name" {
#  value = module.toronto-cluster2.router-03-spoke-floating_ip_name
#}
#
#
#
##
## Local Transit Gateway section
##
#output "local-gateway" {
#  value = module.transit-gateway-local-toronto.gateway
#}
#
#output "local-gateway-connection_1" {
#  value = module.transit-gateway-local-toronto.connection_1
#}
#
#output "local-gateway-connection_2" {
#  value = module.transit-gateway-local-toronto.connection_2
#}
#
#output "local-gateway-vpc_1_name" {
#  value = module.transit-gateway-local-toronto.vpc_1_name
#}
#
#output "local-gateway-vpc_2_name" {
#  value = module.transit-gateway-local-toronto.vpc_2_name
#}