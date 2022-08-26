locals {
  R1_TRANSIT_GATEWAY = module.r1-vpc1-vpc2-transit-gateway.transit-gateway-info
  R2_TRANSIT_GATEWAY = module.r2-vpc1-vpc2-transit-gateway.transit-gateway-info

  R1_TRANSIT_GATEWAY_ID = local.R1_TRANSIT_GATEWAY.id
  R2_TRANSIT_GATEWAY_ID = local.R2_TRANSIT_GATEWAY.id

  R1_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID = local.R1_TRANSIT_GATEWAY.association_default_route_table_id
  R2_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID = local.R2_TRANSIT_GATEWAY.association_default_route_table_id

  R1_VPC1_COMMON = module.r1-vpc1.vpc_common
  R1_VPC2_COMMON = module.r1-vpc2.vpc_common
  R2_VPC1_COMMON = module.r2-vpc1.vpc_common
  R2_VPC2_COMMON = module.r2-vpc2.vpc_common

  R1_VPC1_CIDR = local.R1_VPC1_COMMON.vpc_cidr
  R1_VPC2_CIDR = local.R1_VPC2_COMMON.vpc_cidr
  R2_VPC1_CIDR = local.R2_VPC1_COMMON.vpc_cidr
  R2_VPC2_CIDR = local.R2_VPC2_COMMON.vpc_cidr
}

# ------------------------------------------------
# VPC Transit Gateway attachment between region 1 and 2
# ------------------------------------------------
module "r1_r2-transit-gateway-attachment" {
  source = "../transit-gateway/inter-region/attachment"

  providers = {
    aws        = aws
    aws.aws_r2 = aws.aws_r2
  }

  NAME_PREFIX           = local.NAME_PREFIX
  NUMBER                = "01"
  REGION_1              = var.REGION_1
  REGION_2              = var.REGION_2
  R1_TRANSIT_GATEWAY_ID = local.R1_TRANSIT_GATEWAY_ID
  R2_TRANSIT_GATEWAY_ID = local.R2_TRANSIT_GATEWAY_ID

  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - gateway - inter_region"
      Type : "Inter-region"
    }
  )
}


## ------------------------------------------------
## VPC Transit Gateway route table static routes in:
#   - R1 transit gateway route table -> R2 vpc1/vpc2
#   - R2 transit gateway route table -> R1 vpc1/vpc2
## ------------------------------------------------

#  1: add static route to R2 VPC1 CIDr in R1 transit gateway route table
module "r1_transit_gateway_rtb-r2_vpc1" {
  source = "../transit-gateway/inter-region/transit-gateway-route"

  depends_on = [module.r1_r2-transit-gateway-attachment]

  PEERING_ACCEPTOR                             = module.r1_r2-transit-gateway-attachment.transit-gateway-acceptor-info
  TRANSIT_GATEWAY_ATTACHMENT_ID                = module.r1_r2-transit-gateway-attachment.transit-gateway-attachment-info.id
  TRANSIT_GATEWAY_ROUTE_DESTINATION_CIDR_BLOCK = local.R2_VPC1_CIDR
  TRANSIT_GATEWAY_ROUTE_TABLE_ID               = local.R1_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID
}

#  2: add static route to R2 VPC2 CIDR in R1 transit gateway route table
module "r1_transit_gateway_rtb-r2_vpc2" {
  source = "../transit-gateway/inter-region/transit-gateway-route"

  depends_on = [module.r1_r2-transit-gateway-attachment]

  PEERING_ACCEPTOR                             = module.r1_r2-transit-gateway-attachment.transit-gateway-acceptor-info
  TRANSIT_GATEWAY_ATTACHMENT_ID                = module.r1_r2-transit-gateway-attachment.transit-gateway-attachment-info.id
  TRANSIT_GATEWAY_ROUTE_DESTINATION_CIDR_BLOCK = local.R2_VPC2_CIDR
  TRANSIT_GATEWAY_ROUTE_TABLE_ID               = local.R1_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID
}

#  3: add static route to R1 VPC1 CIDR in R2 transit gateway route table
module "r2_transit_gateway_rtb-r1_vpc1" {
  source = "../transit-gateway/inter-region/transit-gateway-route"

  depends_on = [module.r1_r2-transit-gateway-attachment]

  providers = { aws = aws.aws_r2 }

  PEERING_ACCEPTOR                             = module.r1_r2-transit-gateway-attachment.transit-gateway-acceptor-info
  TRANSIT_GATEWAY_ATTACHMENT_ID                = module.r1_r2-transit-gateway-attachment.transit-gateway-attachment-info.id
  TRANSIT_GATEWAY_ROUTE_DESTINATION_CIDR_BLOCK = local.R1_VPC1_CIDR
  TRANSIT_GATEWAY_ROUTE_TABLE_ID               = local.R2_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID
}

#  4: add static route to R1 VPC2 CIDR in R2 transit gateway route table
module "r2_transit_gateway_rtb-r1_vpc2" {
  source = "../transit-gateway/inter-region/transit-gateway-route"

  depends_on = [module.r1_r2-transit-gateway-attachment]

  providers = { aws = aws.aws_r2 }

  PEERING_ACCEPTOR                             = module.r1_r2-transit-gateway-attachment.transit-gateway-acceptor-info
  TRANSIT_GATEWAY_ATTACHMENT_ID                = module.r1_r2-transit-gateway-attachment.transit-gateway-attachment-info.id
  TRANSIT_GATEWAY_ROUTE_DESTINATION_CIDR_BLOCK = local.R1_VPC2_CIDR
  TRANSIT_GATEWAY_ROUTE_TABLE_ID               = local.R2_TRANSIT_GATEWAY_DEFAULT_ROUTE_TABLE_ID
}


## ------------------------------------------------
## VPC route table routes to allow traffic from:
#   - region1.vpc1 <-> region2.vpc1
#   - region1.vpc2 <-> region2.vpc2
## ------------------------------------------------

# 1: Add route for r2.vpc1 in r1.vpc1 main route table (the one that contains subnets)
module "r1_vpc1_rtb-r2_vpc1" {
  source = "../transit-gateway/inter-region/vpc-route"

  ROUTE_DESTINATION_CIDR_BLOCK = local.R2_VPC1_CIDR
  ROUTE_TABLE_ID               = local.R1_VPC1_COMMON.route_table-main-id
  ROUTE_TRANSIT_GATEWAY_ID     = local.R1_TRANSIT_GATEWAY_ID
}

# 2: Add route for r2.vpc2 in r1.vpc2 main route table (the one that contains subnets)
module "r1_vpc2_rtb-r2_vpc2" {
  source = "../transit-gateway/inter-region/vpc-route"

  ROUTE_DESTINATION_CIDR_BLOCK = local.R2_VPC2_CIDR
  ROUTE_TABLE_ID               = local.R1_VPC2_COMMON.route_table-main-id
  ROUTE_TRANSIT_GATEWAY_ID     = local.R1_TRANSIT_GATEWAY_ID
}

# 3: Add route for r1.vpc1 in r2.vpc1 main route table (the one that contains subnets)
module "r2_vpc1_rtb-r1_vpc1" {
  source = "../transit-gateway/inter-region/vpc-route"

  providers = { aws = aws.aws_r2 }

  ROUTE_DESTINATION_CIDR_BLOCK = local.R1_VPC1_CIDR
  ROUTE_TABLE_ID               = local.R2_VPC1_COMMON.route_table-main-id
  ROUTE_TRANSIT_GATEWAY_ID     = local.R2_TRANSIT_GATEWAY_ID
}

# 3: Add route for r1.vpc2 in r2.vpc2 main route table (the one that contains subnets)
module "r2_vpc2_rtb-r1_vpc2" {
  source = "../transit-gateway/inter-region/vpc-route"

  providers = { aws = aws.aws_r2 }

  ROUTE_DESTINATION_CIDR_BLOCK = local.R1_VPC2_CIDR
  ROUTE_TABLE_ID               = local.R2_VPC2_COMMON.route_table-main-id
  ROUTE_TRANSIT_GATEWAY_ID     = local.R2_TRANSIT_GATEWAY_ID
}
