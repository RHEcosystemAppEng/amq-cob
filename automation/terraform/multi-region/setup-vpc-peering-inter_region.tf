# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC1 (on each side)
# ------------------------------------------------------------------
module "r1_r2-vpc1-peering" {
  source = "../vpc-peering/inter-region"

  providers = {
    aws = aws
    aws.aws_r2 = aws.aws_r2
  }

  NAME_PREFIX = local.NAME_PREFIX
  NUMBER = "01"
  R1_VPC_COMMON = module.r1-vpc1.vpc_common
  R2_VPC_COMMON = module.r2-vpc1.vpc_common
  REGION_1 = var.REGION_1
  REGION_2 = var.REGION_2
  tags = var.tags
}

# ------------------------------------------------------------------
# VPC Peering between region 1 and region 2 - VPC2 (on each side)
# ------------------------------------------------------------------
module "r1_r2-vpc2-peering" {
  source = "../vpc-peering/inter-region"

  providers = {
    aws = aws
    aws.aws_r2 = aws.aws_r2
  }

  NAME_PREFIX = local.NAME_PREFIX
  NUMBER = "02"
  R1_VPC_COMMON = module.r1-vpc2.vpc_common
  R2_VPC_COMMON = module.r2-vpc2.vpc_common
  REGION_1 = var.REGION_1
  REGION_2 = var.REGION_2
  tags = var.tags
}
