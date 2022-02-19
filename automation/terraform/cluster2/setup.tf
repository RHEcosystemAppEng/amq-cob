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
  INSTANCE_NAME = "${var.PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-02"

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

module "broker-05-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_05_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_05_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_05_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_05_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 05",
    "setup: amq_broker"
  ])
}

module "broker-06-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_06_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_06_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_06_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_06_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 06",
    "setup: amq_broker"
  ])
}

module "broker-07-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_07_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_07_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_07_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_07_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 07",
    "setup: amq_broker"
  ])
}

module "broker-08-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_08_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_08_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_08_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_08_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  tags = concat(var.tags, [
    "broker: 08",
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

module "router-03-spoke" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.SPOKE_ROUTER_03_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = var.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.SPOKE_ROUTER_03_MAIN_ZONE
  MAIN_SUBNET_ID = local.SPOKE_ROUTER_03_MAIN_SUBNET_ID
  PRIVATE_IP     = local.SPOKE_ROUTER_03_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router-common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_FILE = var.ROUTER_03_SPOKE_USER_DATA_FILE

  tags = concat(var.tags, [
    "router: spoke",
    "setup: amq_interconnect_router"
  ])
}
