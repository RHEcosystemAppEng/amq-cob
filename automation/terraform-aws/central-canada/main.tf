module "toronto-cluster1" {
  source = "../cluster1"

  ssh_key = var.SSH_KEY

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.CLUSTER1_PRIVATE_IP_PREFIX

  REGION = var.REGION

  AMI_ID = local.REGION_N_AMI[var.REGION].ami_id
  AMI_NAME = local.REGION_N_AMI[var.REGION].ami_name
  INSTANCE_TYPE = var.INSTANCE_TYPE

  CIDR_BLOCKS      = local.CIDR_BLOCKS
  IP_NUMBER_PREFIX = local.IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK  = local.MAIN_CIDR_BLOCK
  NAME_PREFIX      = local.NAME_PREFIX

  TAGS = local.MAIN_TAGS
}
