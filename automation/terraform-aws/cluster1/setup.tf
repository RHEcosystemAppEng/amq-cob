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

  TAGS = var.TAGS
}

module "router-01-hub" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.HUB_ROUTER_01_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.HUB_ROUTER_01_MAIN_SUBNET_ID
  PRIVATE_IP         = local.HUB_ROUTER_01_PRIVATE_IP
  SECURITY_GROUP_IDS = local.ROUTER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Router : "Hub 01"
      Setup : "amq_router"
    }
  )
}

module "router-02-spoke" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.SPOKE_ROUTER_02_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.SPOKE_ROUTER_02_MAIN_SUBNET_ID
  PRIVATE_IP         = local.SPOKE_ROUTER_02_PRIVATE_IP
  SECURITY_GROUP_IDS = local.ROUTER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Router : "Spoke 01"
      Setup : "amq_router"
    }
  )
}
