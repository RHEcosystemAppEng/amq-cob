# ------------------------------------------------------------------
# Transit Gateway Peering between region 1 and region 2 - VPC1/2 (on each side)
# ------------------------------------------------------------------

# Add static route for R2 vpc1/vpc2 in R1 Transit Gateway's default route table and vice-versa
resource "aws_ec2_transit_gateway_route" "r1-r2-vpc" {
  depends_on = [var.PEERING_ACCEPTOR]

  destination_cidr_block         = var.TRANSIT_GATEWAY_ROUTE_DESTINATION_CIDR_BLOCK
  transit_gateway_attachment_id  = var.TRANSIT_GATEWAY_ATTACHMENT_ID
  transit_gateway_route_table_id = var.TRANSIT_GATEWAY_ROUTE_TABLE_ID
}
