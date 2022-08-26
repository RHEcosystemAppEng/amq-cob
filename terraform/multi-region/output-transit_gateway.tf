#
# R1 transit gateway section
#
output "r1-transit_gateway-id" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-info.id
}

output "r1-transit_gateway-name" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-info.tags.Name
}

output "r1-transit_gateway-attachment-01-id" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-vpc1-attachment-info.id
}

output "r1-transit_gateway-attachment-01-name" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-vpc1-attachment-info.tags.Name
}

output "r1-transit_gateway-attachment-02-id" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-vpc2-attachment-info.id
}

output "r1-transit_gateway-attachment-02-name" {
  value = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-vpc2-attachment-info.tags.Name
}

#
# R2 transit gateway section
#
output "r2-transit_gateway-id" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-info.id
}

output "r2-transit_gateway-name" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-info.tags.Name
}

output "r2-transit_gateway-attachment-01-id" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-vpc1-attachment-info.id
}

output "r2-transit_gateway-attachment-01-name" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-vpc1-attachment-info.tags.Name
}

output "r2-transit_gateway-attachment-02-id" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-vpc2-attachment-info.id
}

output "r2-transit_gateway-attachment-02-name" {
  value = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-vpc2-attachment-info.tags.Name
}

#
# R1-R2 transit gateway section
#
output "r1-r2-transit_gateway_attachment-id" {
  value = module.r1_r2-transit-gateway-attachment.transit-gateway-attachment-info.id
}
