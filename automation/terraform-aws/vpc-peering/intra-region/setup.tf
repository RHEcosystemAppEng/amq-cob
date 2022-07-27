# ------------------------------------------------
# VPC Peering for region 1 - between vpc1 and vpc2
# ------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "vpc1-vpc2" {
  peer_vpc_id = var.VPC1_COMMON.vpc_id
  vpc_id      = var.VPC2_COMMON.vpc_id
  auto_accept = true

  tags = var.tags
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-vpc1_to_vpc2" {
  route_table_id            = var.VPC1_COMMON.route_table-main-id
  destination_cidr_block    = var.VPC2_COMMON.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-vpc2_to_vpc1" {
  route_table_id            = var.VPC2_COMMON.route_table-main-id
  destination_cidr_block    = var.VPC1_COMMON.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}
