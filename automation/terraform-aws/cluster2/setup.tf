module "common" {
  source = "../cluster"

  PREFIX            = var.PREFIX
  PRIVATE_IP_PREFIX = var.PRIVATE_IP_PREFIX

  REGION  = var.REGION
  SSH_KEY = var.SSH_KEY

  AMI_ID        = var.AMI_ID
  AMI_NAME      = var.AMI_NAME
  INSTANCE_TYPE = var.INSTANCE_TYPE

  CIDR_BLOCKS      = var.CIDR_BLOCKS
  IP_NUMBER_PREFIX = var.IP_NUMBER_PREFIX
  MAIN_CIDR_BLOCK  = var.MAIN_CIDR_BLOCK
  NAME_PREFIX      = var.NAME_PREFIX

  INSTANCE_INFO = var.INSTANCE_INFO

  KEY_NFS = var.KEY_NFS
  KEY_BROKER_01 = var.KEY_BROKER_01
  KEY_BROKER_02 = var.KEY_BROKER_02
  KEY_BROKER_03 = var.KEY_BROKER_03
  KEY_BROKER_04 = var.KEY_BROKER_04

  TAGS = var.TAGS
}

module "router-03-spoke" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.SPOKE_ROUTER_03_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.SPOKE_ROUTER_03_MAIN_SUBNET_ID
  PRIVATE_IP         = local.SPOKE_ROUTER_03_PRIVATE_IP
  SECURITY_GROUP_IDS = local.ROUTER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Router : "Spoke 02"
      Setup : "amq_router"
    }
  )
}
