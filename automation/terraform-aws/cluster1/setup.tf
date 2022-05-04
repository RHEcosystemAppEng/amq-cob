module "common" {
  source = "../common"

  CIDR_BLOCKS     = var.CIDR_BLOCKS
  MAIN_CIDR_BLOCK = var.MAIN_CIDR_BLOCK
  NAME_PREFIX     = var.NAME_PREFIX

  TAGS = merge(
    local.tags,
    {
      Setup : "common"
    }
  )
}

module "nfs-server" {
  source = "../instance"

  SSH_KEY       = var.ssh_key
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-01"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  SUBNET_ID          = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP         = local.NFS_PRIVATE_IP
  SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID]

  TAGS = merge(
    local.tags,
    {
      Setup : "NFS server"
    }
  )
}

module "broker-01-live" {
  source = "../instance"

  SSH_KEY       = var.ssh_key
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_01_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  SUBNET_ID          = local.BROKER_01_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_01_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Live 01"
      Setup : "amq_broker"
    }
  )
  #  depends_on = [module.nfs-server]
}

module "broker-02-bak" {
  source = "../instance"

  SSH_KEY       = var.ssh_key
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_02_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  SUBNET_ID          = local.BROKER_02_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_02_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Bak 01"
      Setup : "amq_broker"
    }
  )
}

module "broker-03-live" {
  source = "../instance"

  SSH_KEY       = var.ssh_key
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_03_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  SUBNET_ID          = local.BROKER_03_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_03_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Live 02"
      Setup : "amq_broker"
    }
  )
}

module "broker-04-bak" {
  source = "../instance"

  SSH_KEY       = var.ssh_key
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_04_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  SUBNET_ID          = local.BROKER_04_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_04_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Bak 02"
      Setup : "amq_broker"
    }
  )
}


#
#module "router-common" {
#  source = "../router/common"
#
#  ibmcloud_api_key = var.ibmcloud_api_key
#
#  INSTANCE_PROFILE = var.INSTANCE_PROFILE
#
#  SECURITY_GROUP_NAME = "${var.SECURITY_GROUP_PREFIX}-03"
#  VPC_ID              = module.common.vpc_id
#
#  tags = concat(var.tags, [
#    "setup: amq_interconnect_router-common"
#  ])
#}
#
#module "router-01-hub" {
#  source = "../router/hub-n-spoke"
#
#  ibmcloud_api_key = var.ibmcloud_api_key
#  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac
#
#  PREFIX        = var.PREFIX
#  INSTANCE_NAME = "${var.PREFIX}-${local.HUB_ROUTER_01_SUFFIX}"
#
#  IMAGE            = data.ibm_is_image.redhat_8_min
#  INSTANCE_PROFILE = var.INSTANCE_PROFILE
#
#  REGION         = local.REGION
#  MAIN_ZONE      = local.HUB_ROUTER_01_MAIN_ZONE
#  MAIN_SUBNET_ID = local.HUB_ROUTER_01_MAIN_SUBNET_ID
#  PRIVATE_IP     = local.HUB_ROUTER_01_PRIVATE_IP
#
#  VPC                    = module.common.vpc
#  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
#  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
#  SECURITY_GROUP_3_ID    = module.router-common.custom_sg_3_id
#  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg
#
#  tags = concat(var.tags, [
#    "router: hub",
#    "setup: amq_interconnect_router"
#  ])
#}
#
#module "router-02-spoke" {
#  source = "../router/hub-n-spoke"
#
#  ibmcloud_api_key = var.ibmcloud_api_key
#  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac
#
#  PREFIX        = var.PREFIX
#  INSTANCE_NAME = "${var.PREFIX}-${local.SPOKE_ROUTER_02_SUFFIX}"
#
#  IMAGE            = data.ibm_is_image.redhat_8_min
#  INSTANCE_PROFILE = var.INSTANCE_PROFILE
#
#  REGION         = local.REGION
#  MAIN_ZONE      = local.SPOKE_ROUTER_02_MAIN_ZONE
#  MAIN_SUBNET_ID = local.SPOKE_ROUTER_02_MAIN_SUBNET_ID
#  PRIVATE_IP     = local.SPOKE_ROUTER_02_PRIVATE_IP
#
#  VPC                    = module.common.vpc
#  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
#  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
#  SECURITY_GROUP_3_ID    = module.router-common.custom_sg_3_id
#  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg
#
#  tags = concat(var.tags, [
#    "router: spoke",
#    "setup: amq_interconnect_router"
#  ])
#}
