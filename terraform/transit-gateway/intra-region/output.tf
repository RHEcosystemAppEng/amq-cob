output "transit-gateway-info" {
  value = aws_ec2_transit_gateway.vpc1-vpc2
}

output "transit-gateway-vpc1-attachment-info" {
  value = aws_ec2_transit_gateway_vpc_attachment.vpc1-attachment
}

output "transit-gateway-vpc2-attachment-info" {
  value = aws_ec2_transit_gateway_vpc_attachment.vpc2-attachment
}
