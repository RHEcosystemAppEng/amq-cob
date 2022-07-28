
output "r1-r2-vpc1-peering_connection" {
  value = aws_vpc_peering_connection.r1-r2-vpc1.id
}

output "r1-r2-vpc1-peering_connection_accept_status" {
  value = aws_vpc_peering_connection.r1-r2-vpc1.accept_status
}

output "r1-r2-vpc2-peering_connection" {
  value = aws_vpc_peering_connection.r1-r2-vpc2.id
}

output "r1-r2-vpc2-peering_connection_accept_status" {
  value = aws_vpc_peering_connection.r1-r2-vpc2.accept_status
}
