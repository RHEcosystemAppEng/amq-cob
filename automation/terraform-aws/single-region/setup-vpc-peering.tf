# ------------------------------------------------
# VPC Peering for region 1 - between vpc1 and vpc2
# ------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "vpc1-vpc2" {
  peer_vpc_id = module.vpc1.vpc_common.vpc_id
  vpc_id      = module.vpc2.vpc_common.vpc_id
  auto_accept = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering",
    }
  )
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-vpc1_to_vpc2" {
  route_table_id            = module.vpc1.vpc_common.route_table-main-id
  destination_cidr_block    = module.vpc2.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "peering-vpc2_to_vpc1" {
  route_table_id            = module.vpc2.vpc_common.route_table-main-id
  destination_cidr_block    = module.vpc1.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1-vpc2.id
}
