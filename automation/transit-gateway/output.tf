output "gateway-01-name" {
  value = module.transit_gateway_for_cluster-1_n_3.gateway.name
}

output "gateway-02-name" {
  value = module.transit_gateway_for_cluster-2_n_4.gateway.name
}

output "gateway-01-region" {
  value = module.transit_gateway_for_cluster-1_n_3.gateway.location
}

output "gateway-02-region" {
  value = module.transit_gateway_for_cluster-2_n_4.gateway.location
}

output "gateway-01-connection_1" {
  value = module.transit_gateway_for_cluster-1_n_3.connection_1
}

output "gateway-02-connection_1" {
  value = module.transit_gateway_for_cluster-2_n_4.connection_1
}

output "gateway-01-connection_2" {
  value = module.transit_gateway_for_cluster-1_n_3.connection_2
}

output "gateway-02-connection_2" {
  value = module.transit_gateway_for_cluster-2_n_4.connection_2
}

output "vpc_name_dallas_1" {
  value = data.ibm_is_vpc.amq_vpc_dallas_1.name
}

output "vpc_id_dallas_1" {
  value = data.ibm_is_vpc.amq_vpc_dallas_1.id
}

output "vpc_resource_crn_dallas_1" {
  value = data.ibm_is_vpc.amq_vpc_dallas_1.resource_crn
}

output "vpc_name_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_dallas_2.name
}

output "vpc_id_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_dallas_2.id
}

output "vpc_resource_crn_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_dallas_2.resource_crn
}

output "vpc_name_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_toronto_1.name
}

output "vpc_id_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_toronto_1.id
}

output "vpc_resource_crn_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_toronto_1.resource_crn
}


#
# Local Transit Gateway section - Toronto
#
output "local-transit_gateway-toronto" {
  value = module.transit-gateway-local-toronto.gateway.name
}

output "local-transit_gateway_location-toronto" {
  value = module.transit-gateway-local-toronto.gateway.location
}

output "local-transit_gateway_conn_1-toronto" {
  value = module.transit-gateway-local-toronto.connection_1
}

output "local-transit_gateway_conn_2-toronto" {
  value = module.transit-gateway-local-toronto.connection_2
}

#
# Local Transit Gateway section - Dallas
#
output "local-transit_gateway-dallas" {
  value = module.transit-gateway-local-dallas.gateway.name
}

output "local-transit_gateway_location-dallas" {
  value = module.transit-gateway-local-dallas.gateway.location
}

output "local-transit_gateway_conn_1-dallas" {
  value = module.transit-gateway-local-dallas.connection_1
}

output "local-transit_gateway_conn_2-dallas" {
  value = module.transit-gateway-local-dallas.connection_2
}
