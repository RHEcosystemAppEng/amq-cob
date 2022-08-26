# ------------------------------------------------------------------
# Transit Gateway Peering between region 1 and region 2 - VPC1/2 (on each side)
# ------------------------------------------------------------------

# Add route to r2.vpc2 (or r2.vpc1) in r1.vpc2 (or r1.vpc1) main route table (the one that contains subnets) and vice-versa
resource "aws_route" "transit-gateway-r1-r2-vpc" {
  route_table_id         = var.ROUTE_TABLE_ID
  destination_cidr_block = var.ROUTE_DESTINATION_CIDR_BLOCK
  transit_gateway_id     = var.ROUTE_TRANSIT_GATEWAY_ID
}

