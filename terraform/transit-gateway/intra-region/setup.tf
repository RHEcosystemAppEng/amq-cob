# ------------------------------------------------
# Transit Gateway for region 1 - between vpc1 and vpc2
# ------------------------------------------------

data "aws_subnets" "vpc1-all_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.VPC1_COMMON.vpc_id]
  }
}

data "aws_subnets" "vpc2-all_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.VPC2_COMMON.vpc_id]
  }
}

# Add the Transit Gateway connection
resource "aws_ec2_transit_gateway" "vpc1-vpc2" {
  amazon_side_asn                = var.AMAZON_SIDE_ASN
  auto_accept_shared_attachments = "enable"
  description                    = "vpc1-vpc2 transit gateway"

  tags = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1-attachment" {
  subnet_ids         = data.aws_subnets.vpc1-all_subnets.ids
  transit_gateway_id = aws_ec2_transit_gateway.vpc1-vpc2.id
  vpc_id             = var.VPC1_COMMON.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX}-vpc1"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2-attachment" {
  subnet_ids         = data.aws_subnets.vpc2-all_subnets.ids
  transit_gateway_id = aws_ec2_transit_gateway.vpc1-vpc2.id
  vpc_id             = var.VPC2_COMMON.vpc_id

  tags = merge(
    var.tags,
    {
      Name : "${var.NAME_PREFIX}-vpc2"
    }
  )
}

# Add route to VPC2 in VPC1 main route table (the one that contains subnets)
resource "aws_route" "transit-gateway-vpc1_to_vpc2" {
  route_table_id         = var.VPC1_COMMON.route_table-main-id
  destination_cidr_block = var.VPC2_COMMON.vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.vpc1-vpc2.id
}

# Add route to VPC1 in VPC2 main route table (the one that contains subnets)
resource "aws_route" "transit-gateway-vpc2_to_vpc1" {
  route_table_id         = var.VPC2_COMMON.route_table-main-id
  destination_cidr_block = var.VPC1_COMMON.vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.vpc1-vpc2.id
}
