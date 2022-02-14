
output "gateway" {
  value = ibm_tg_gateway.interconnect_transit_gateway
}

output "connection_1" {
  value = ibm_tg_connection.transit_gateway_conn_1.name
}

output "connection_2" {
  value = ibm_tg_connection.transit_gateway_conn_2.name
}

output "vpc_1_name" {
  value = var.VPC_1.name
}

output "vpc_1_id" {
  value = var.VPC_1.id
}

output "vpc_1_resource_crn" {
  value = var.VPC_1.resource_crn
}

output "vpc_2_name" {
  value = var.VPC_2.name
}

output "vpc_2_id" {
  value = var.VPC_2.id
}

output "vpc_2_resource_crn" {
  value = var.VPC_2.resource_crn
}
