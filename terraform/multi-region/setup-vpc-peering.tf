# ------------------------------------------------
# VPC Peering for region 1 - between vpc1 and vpc2
# ------------------------------------------------
module "r1-vpc1-vpc2-peering" {
  source = "../vpc-peering/intra-region"

  VPC1_COMMON = module.r1-vpc1.vpc_common
  VPC2_COMMON = module.r1-vpc2.vpc_common
  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering - intra_region"
      Type : "Intra-region"
    }
  )
}


# ------------------------------------------------
# VPC Peering for region 2 - between vpc1 and vpc2
# ------------------------------------------------
module "r2-vpc1-vpc2-peering" {
  source = "../vpc-peering/intra-region"

  providers = {aws = aws.aws_r2}

  VPC1_COMMON = module.r2-vpc1.vpc_common
  VPC2_COMMON = module.r2-vpc2.vpc_common
  tags = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX} - peering - intra_region"
      Type : "Intra-region"
    }
  )
}
