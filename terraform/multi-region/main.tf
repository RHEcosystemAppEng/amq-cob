module "r1-vpc1" {
  source = "../vpc1"
  providers = {
    aws = aws
  }

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.R1_VPC1_PRIVATE_IP_PREFIX
  REGION            = var.REGION_1
  SSH_KEY           = var.SSH_KEY
  AMI_ID            = local.R1_AMI_ID
  AMI_NAME          = var.AMI_NAME
  INSTANCE_TYPE     = var.INSTANCE_TYPE
  IP_NUMBER_PREFIX  = local.R1_VPC1_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK   = local.R1_VPC1_MAIN_CIDR_BLOCK
  NAME_PREFIX       = local.NAME_PREFIX

  KEY_NFS       = local.KEY_NFS
  KEY_BROKER_01 = local.KEY_BROKER_01
  KEY_BROKER_02 = local.KEY_BROKER_02
  KEY_BROKER_03 = local.KEY_BROKER_03
  KEY_BROKER_04 = local.KEY_BROKER_04

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-1"
      Cluster : "cluster 1"
      VPC : "vpc 1"
      Region : "region 1"
    }
  )
}

module "r1-vpc2" {
  source = "../vpc2"
  providers = {
    aws = aws
  }

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.R1_VPC2_PRIVATE_IP_PREFIX
  REGION            = var.REGION_1
  SSH_KEY           = var.SSH_KEY
  AMI_ID            = local.R1_AMI_ID
  AMI_NAME          = var.AMI_NAME
  INSTANCE_TYPE     = var.INSTANCE_TYPE
  IP_NUMBER_PREFIX  = local.R1_VPC2_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK   = local.R1_VPC2_MAIN_CIDR_BLOCK
  NAME_PREFIX       = local.NAME_PREFIX

  KEY_NFS       = local.KEY_NFS
  KEY_BROKER_01 = local.KEY_BROKER_01
  KEY_BROKER_02 = local.KEY_BROKER_02
  KEY_BROKER_03 = local.KEY_BROKER_03
  KEY_BROKER_04 = local.KEY_BROKER_04

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-2"
      Cluster : "cluster 2"
      VPC : "vpc 2"
      Region : "region 1"
    }
  )
}

module "r2-vpc1" {
  source = "../vpc1"
  providers = {
    aws = aws.aws_r2
  }

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.R2_VPC1_PRIVATE_IP_PREFIX
  REGION            = var.REGION_2
  SSH_KEY           = var.SSH_KEY
  AMI_ID            = local.R2_AMI_ID
  AMI_NAME          = var.AMI_NAME
  INSTANCE_TYPE     = var.INSTANCE_TYPE
  IP_NUMBER_PREFIX  = local.R2_VPC1_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK   = local.R2_VPC1_MAIN_CIDR_BLOCK
  NAME_PREFIX       = local.NAME_PREFIX

  KEY_NFS       = local.KEY_NFS
  KEY_BROKER_01 = local.KEY_BROKER_01
  KEY_BROKER_02 = local.KEY_BROKER_02
  KEY_BROKER_03 = local.KEY_BROKER_03
  KEY_BROKER_04 = local.KEY_BROKER_04

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-1"
      Cluster : "cluster 1"
      VPC : "vpc 1"
      Region : "region 2"
    }
  )
}

module "r2-vpc2" {
  source = "../vpc2"
  providers = {
    aws = aws.aws_r2
  }

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.R2_VPC2_PRIVATE_IP_PREFIX
  REGION            = var.REGION_2
  SSH_KEY           = var.SSH_KEY
  AMI_ID            = local.R2_AMI_ID
  AMI_NAME          = var.AMI_NAME
  INSTANCE_TYPE     = var.INSTANCE_TYPE
  IP_NUMBER_PREFIX  = local.R2_VPC2_IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK   = local.R2_VPC2_MAIN_CIDR_BLOCK
  NAME_PREFIX       = local.NAME_PREFIX

  KEY_NFS       = local.KEY_NFS
  KEY_BROKER_01 = local.KEY_BROKER_01
  KEY_BROKER_02 = local.KEY_BROKER_02
  KEY_BROKER_03 = local.KEY_BROKER_03
  KEY_BROKER_04 = local.KEY_BROKER_04

  TAGS = merge(
    var.tags,
    {
      Name : "${local.NAME_PREFIX}-2"
      Cluster : "cluster 2"
      VPC : "vpc 2"
      Region : "region 2"
    }
  )
}
