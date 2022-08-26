output "transit-gateway-attachment-info" {
  value = aws_ec2_transit_gateway_peering_attachment.r1-r2-peering_attachment
}

output "transit-gateway-acceptor-info" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.r1-r2-peering_attachment_acceptor
}
