
output "r1-r2-vpc1-peering_connection" {
  value = module.r1_r2-vpc1-peering.peering-info.id
}

output "r1-r2-vpc1-peering_connection_accept_status" {
  value = module.r1_r2-vpc1-peering.peering-info.accept_status
}

output "r1-r2-vpc2-peering_connection" {
  value = module.r1_r2-vpc2-peering.peering-info.id
}

output "r1-r2-vpc2-peering_connection_accept_status" {
  value = module.r1_r2-vpc2-peering.peering-info.accept_status
}
