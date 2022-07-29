# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC1 (on each side)
# ------------------------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "r1-r2-vpc1" {
  peer_region = var.REGION_2
  peer_vpc_id = module.r2-vpc1.vpc_common.vpc_id
  vpc_id      = module.r1-vpc1.vpc_common.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering - inter_region - 01"
      Type : "Inter-region"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

resource "aws_vpc_peering_connection_accepter" "r2-vpc1-peer-acceptor" {
  provider                  = aws.aws_r2
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc1.id
  auto_accept               = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering acceptor - 01"
      Type : "Acceptor in R2"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

# Add route to r2.VPC1 in r1.VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-r2-vpc1" {
  route_table_id            = module.r1-vpc1.vpc_common.route_table-main-id
  destination_cidr_block    = module.r2-vpc1.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc1.id
}

# Add route to r1.VPC1 in r2.VPC1 main route table (the one that contains subnets)
resource "aws_route" "peering-r2-r1-vpc1" {
  provider                  = aws.aws_r2
  route_table_id            = module.r2-vpc1.vpc_common.route_table-main-id
  destination_cidr_block    = module.r1-vpc1.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc1.id
}

# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC2 (on each side)
# ------------------------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "r1-r2-vpc2" {
  peer_region = var.REGION_2
  peer_vpc_id = module.r2-vpc2.vpc_common.vpc_id
  vpc_id      = module.r1-vpc2.vpc_common.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering - inter_region - 02"
      Type : "Inter-region"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

resource "aws_vpc_peering_connection_accepter" "r2-vpc2-peer-acceptor" {
  provider                  = aws.aws_r2
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc2.id
  auto_accept               = true

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering acceptor - 02"
      Type : "Acceptor in R2"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

# Add route to r2.vpc2 in r1.vpc2 main route table (the one that contains subnets)
resource "aws_route" "peering-r1-r2-vpc2" {
  route_table_id            = module.r1-vpc2.vpc_common.route_table-main-id
  destination_cidr_block    = module.r2-vpc2.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc2.id
}

# Add route to r1.vpc2 in r2.vpc2 main route table (the one that contains subnets)
resource "aws_route" "peering-r2-r1-vpc2" {
  provider                  = aws.aws_r2
  route_table_id            = module.r2-vpc2.vpc_common.route_table-main-id
  destination_cidr_block    = module.r1-vpc2.vpc_common.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc2.id
}

