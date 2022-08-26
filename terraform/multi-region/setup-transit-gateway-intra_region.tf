locals {
  INTRA_REGION_TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - gateway - intra_region"
      Type : "Intra-region"
    }
  )

}

# ------------------------------------------------
# VPC Transit Gateway for region 1 - between vpc1 and vpc2
# ------------------------------------------------
module "r1-vpc1-vpc2-transit-gateway" {
  source = "../transit-gateway/intra-region"

  VPC1_COMMON     = module.r1-vpc1.vpc_common
  VPC2_COMMON     = module.r1-vpc2.vpc_common
  AMAZON_SIDE_ASN = "4200000001"
  NAME_PREFIX     = local.NAME_PREFIX
  tags            = local.INTRA_REGION_TAGS
}

# ------------------------------------------------
# VPC Transit Gateway for region 2 - between vpc1 and vpc2
# ------------------------------------------------
module "r2-vpc1-vpc2-transit-gateway" {
  source = "../transit-gateway/intra-region"

  providers = { aws = aws.aws_r2 }

  VPC1_COMMON     = module.r2-vpc1.vpc_common
  VPC2_COMMON     = module.r2-vpc2.vpc_common
  AMAZON_SIDE_ASN = "4200000002"
  NAME_PREFIX     = local.NAME_PREFIX
  tags            = local.INTRA_REGION_TAGS
}

