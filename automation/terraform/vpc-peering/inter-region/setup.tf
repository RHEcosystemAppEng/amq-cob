# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC1/2 (on each side)
# ------------------------------------------------------------------

# Add the VPC peering connection
resource "aws_vpc_peering_connection" "r1-r2-vpc" {
  peer_region = var.REGION_2
  peer_vpc_id = var.R2_VPC_COMMON.vpc_id
  vpc_id      = var.R1_VPC_COMMON.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX} - peering - inter_region - ${var.NUMBER}"
      Type : "Inter-region"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

resource "aws_vpc_peering_connection_accepter" "r2-vpc-peer-acceptor" {
  provider                  = aws.aws_r2
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc.id
  auto_accept               = true

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX} - peering acceptor - ${var.NUMBER}"
      Type : "Acceptor in R2"
      Region1 : var.REGION_1
      Region2 : var.REGION_2
    }
  )
}

# Add route to r2.vpc2 (or r2.vpc1) in r1.vpc2 (or r1.vpc1) main route table (the one that contains subnets)
resource "aws_route" "peering-r1-r2-vpc" {
  route_table_id            = var.R1_VPC_COMMON.route_table-main-id
  destination_cidr_block    = var.R2_VPC_COMMON.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc.id
}

# Add route to r1.vpc2 (or r1.vpc1) in r2.vpc2 (or r2.vpc1) main route table (the one that contains subnets)
resource "aws_route" "peering-r2-r1-vpc" {
  provider                  = aws.aws_r2
  route_table_id            = var.R2_VPC_COMMON.route_table-main-id
  destination_cidr_block    = var.R1_VPC_COMMON.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.r1-r2-vpc.id
}
