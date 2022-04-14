module "common" {
  source = "../common"
  PREFIX = var.PREFIX

  ibmcloud_api_key = var.ibmcloud_api_key

  REGION = local.REGION

  ZONE1 = var.ZONE1
  ZONE2 = var.ZONE2
  ZONE3 = var.ZONE3

  ZONE1_CIDR = var.ZONE1_CIDR
  ZONE2_CIDR = var.ZONE2_CIDR
  ZONE3_CIDR = var.ZONE3_CIDR

  VPC_NAME                        = var.VPC_NAME
  VPC_DEFAULT_SECURITY_GROUP_NAME = "${var.VPC_NAME}-default-sg"

  SUBNET_1_NAME = "${var.SUBNET_PREFIX}-01-${var.ZONE1}"
  SUBNET_2_NAME = "${var.SUBNET_PREFIX}-02-${var.ZONE2}"
  SUBNET_3_NAME = "${var.SUBNET_PREFIX}-03-${var.ZONE3}"

  SECURITY_GROUP_1_NAME = "${var.SECURITY_GROUP_PREFIX}-01"
  SECURITY_GROUP_2_NAME = "${var.SECURITY_GROUP_PREFIX}-02"

  tags = concat(var.tags, [
    "setup: common"
  ])
}

module "nfs-server" {
  source = "../nfs"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-01"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.NFS_MAIN_ZONE
  MAIN_SUBNET_ID = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP     = local.NFS_PRIVATE_IP

  VPC                    = module.common.vpc
  MAIN_SECURITY_GROUP_ID = module.common.custom_sg_1_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = var.tags
}

module "broker-01-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_01_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_01_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_01_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_01_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 01",
    "setup: amq_broker"
  ])
}

module "broker-02-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_02_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_02_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_02_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_02_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 02",
    "setup: amq_broker"
  ])
}

module "broker-03-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_03_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_03_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_03_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_03_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 03",
    "setup: amq_broker"
  ])
}

module "broker-04-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_04_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_04_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_04_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_04_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 04",
    "setup: amq_broker"
  ])
}

module "router-common" {
  source = "../router/common"

  ibmcloud_api_key = var.ibmcloud_api_key

  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  SECURITY_GROUP_NAME = "${var.SECURITY_GROUP_PREFIX}-03"
  VPC_ID              = module.common.vpc_id

  tags = concat(var.tags, [
    "setup: amq_interconnect_router-common"
  ])
}

module "router-01-hub" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.HUB_ROUTER_01_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.HUB_ROUTER_01_MAIN_ZONE
  MAIN_SUBNET_ID = local.HUB_ROUTER_01_MAIN_SUBNET_ID
  PRIVATE_IP     = local.HUB_ROUTER_01_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router-common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "router: hub",
    "setup: amq_interconnect_router"
  ])
}

module "router-02-spoke" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.SPOKE_ROUTER_02_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.SPOKE_ROUTER_02_MAIN_ZONE
  MAIN_SUBNET_ID = local.SPOKE_ROUTER_02_MAIN_SUBNET_ID
  PRIVATE_IP     = local.SPOKE_ROUTER_02_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router-common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "router: spoke",
    "setup: amq_interconnect_router"
  ])
}
