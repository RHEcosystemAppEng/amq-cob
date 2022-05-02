module "toronto-cluster1" {
  source = "../cluster1"

  ssh_key = var.SSH_KEY

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER1_PRIVATE_IP_PREFIX

#  SECURITY_GROUP_PREFIX = local.SECURITY_GROUP_PREFIX
#  SUBNET_PREFIX         = local.SUBNET_PREFIX
#
#  REGION     = var.REGION
#  ZONE1      = local.ZONE1
#  ZONE1_CIDR = local.CLUSTER1_ZONE1_CIDR
#  ZONE2      = local.ZONE2
#  ZONE2_CIDR = local.CLUSTER1_ZONE2_CIDR
#  ZONE3      = local.ZONE3
#  ZONE3_CIDR = local.CLUSTER1_ZONE3_CIDR
#  VPC_NAME   = local.CLUSTER1_VPC_NAME

  REGION = var.REGION

  AMI_ID = local.REGION_N_AMI[var.REGION].ami_id
  AMI_NAME = local.REGION_N_AMI[var.REGION].ami_name

  CIDR_BLOCKS      = local.CIDR_BLOCKS
  IP_NUMBER_PREFIX = local.IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK  = local.MAIN_CIDR_BLOCK
  NAME_PREFIX      = local.NAME_PREFIX

  TAGS = local.MAIN_TAGS
}
