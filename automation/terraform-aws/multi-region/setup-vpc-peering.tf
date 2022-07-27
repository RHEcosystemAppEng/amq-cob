# ------------------------------------------------
# VPC Peering for region 1 - between vpc1 and vpc2
# ------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "r1-vpc1-vpc2" {
  peer_vpc_id = module.r1-vpc1.vpc_common.vpc_id
  vpc_id      = module.r1-vpc2.vpc_common.vpc_id
  auto_accept = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering"
      Type : "Intra-region"
    }
  )
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-vpc1_to_vpc2" {
  route_table_id            = module.r1-vpc1.vpc_common.route_table-main-id
  destination_cidr_block    = module.r1-vpc2.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-vpc2_to_vpc1" {
  route_table_id            = module.r1-vpc2.vpc_common.route_table-main-id
  destination_cidr_block    = module.r1-vpc1.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-vpc1-vpc2.id
}


# ------------------------------------------------
# VPC Peering for region 2 - between vpc1 and vpc2
# ------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "r2-vpc1-vpc2" {
  provider = aws.aws_r2

  peer_vpc_id = module.r2-vpc1.vpc_common.vpc_id
  vpc_id      = module.r2-vpc2.vpc_common.vpc_id
  auto_accept = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering"
      Type : "Intra-region"
    }
  )
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-r2-vpc1_to_vpc2" {
  provider = aws.aws_r2

  route_table_id            = module.r2-vpc1.vpc_common.route_table-main-id
  destination_cidr_block    = module.r2-vpc2.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r2-vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "peering-r2-vpc2_to_vpc1" {
  provider = aws.aws_r2

  route_table_id            = module.r2-vpc2.vpc_common.route_table-main-id
  destination_cidr_block    = module.r2-vpc1.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r2-vpc1-vpc2.id
}
