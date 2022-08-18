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
  value = data.ibm_is_vpc.amq_vpc_region2_1.name
}

output "vpc_id_dallas_1" {
  value = data.ibm_is_vpc.amq_vpc_region2_1.id
}

output "vpc_resource_crn_dallas_1" {
  value = data.ibm_is_vpc.amq_vpc_region2_1.resource_crn
}

output "vpc_name_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_region2_2.name
}

output "vpc_id_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_region2_2.id
}

output "vpc_resource_crn_dallas_2" {
  value = data.ibm_is_vpc.amq_vpc_region2_2.resource_crn
}

output "vpc_name_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_region1_1.name
}

output "vpc_id_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_region1_1.id
}

output "vpc_resource_crn_tor_1" {
  value = data.ibm_is_vpc.amq_vpc_region1_1.resource_crn
}

output "vpc_name_tor_2" {
  value = data.ibm_is_vpc.amq_vpc_region1_2.name
}

output "vpc_id_tor_2" {
  value = data.ibm_is_vpc.amq_vpc_region1_2.id
}

output "vpc_resource_crn_tor_2" {
  value = data.ibm_is_vpc.amq_vpc_region1_2.resource_crn
}
