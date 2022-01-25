module "common" {
  source = "../common"
  PREFIX = var.PREFIX

  ibmcloud_api_key = var.ibmcloud_api_key

  REGION = local.REGION

  ZONE1 = local.ZONE1
  ZONE2 = local.ZONE2
  ZONE3 = local.ZONE3

  ZONE1_CIDR = local.ZONE1_CIDR
  ZONE2_CIDR = local.ZONE2_CIDR
  ZONE3_CIDR = local.ZONE3_CIDR

  VPC_NAME                        = local.VPC_NAME
  VPC_DEFAULT_SECURITY_GROUP_NAME = local.VPC_DEFAULT_SECURITY_GROUP_NAME

  SUBNET_1_NAME = "${local.SUBNET_PREFIX}-${local.ZONE1}-01"
  SUBNET_2_NAME = "${local.SUBNET_PREFIX}-${local.ZONE2}-01"
  SUBNET_3_NAME = "${local.SUBNET_PREFIX}-${local.ZONE3}-01"

  SECURITY_GROUP_1_NAME = "${local.SECURITY_GROUP_PREFIX}-01"
  SECURITY_GROUP_2_NAME = "${local.SECURITY_GROUP_PREFIX}-02"

  tags = var.tags
}

module "nfs-server" {
  source = "../nfs"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-01"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.NFS_MAIN_ZONE
  MAIN_SUBNET_ID = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP     = local.NFS_PRIVATE_IP

  VPC                    = module.common.vpc
  MAIN_SECURITY_GROUP_ID = module.common.custom_sg_1_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../nfs/files/initial_setup-01.sh"

  tags = var.tags
}

module "broker-09-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_09_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_09_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_09_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_09_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster3/broker9_live5/initial_setup-01.sh"

  tags = var.tags
}

module "broker-10-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_10_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_10_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_10_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_10_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster3/broker10_bak5/initial_setup-01.sh"

  tags = var.tags
}

module "broker-11-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_11_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_11_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_11_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_11_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster3/broker11_live6/initial_setup-01.sh"

  tags = var.tags
}

module "broker-12-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_12_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_12_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_12_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_12_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster3/broker12_bak6/initial_setup-01.sh"

  tags = var.tags
}

module "router_common" {
  source = "../router/common"

  ibmcloud_api_key = var.ibmcloud_api_key

  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  SECURITY_GROUP_NAME = "${local.SECURITY_GROUP_PREFIX}-03"
  VPC_ID              = module.common.vpc_id

  tags = var.tags
}

module "router-04-hub" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.HUB_ROUTER_04_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.HUB_ROUTER_04_MAIN_ZONE
  MAIN_SUBNET_ID = local.HUB_ROUTER_04_MAIN_SUBNET_ID
  PRIVATE_IP     = local.HUB_ROUTER_04_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router_common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../router/hub-router4/initial_setup-01.sh"

  tags = var.tags
}

module "router-05-spoke" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.SPOKE_ROUTER_05_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.SPOKE_ROUTER_05_MAIN_ZONE
  MAIN_SUBNET_ID = local.SPOKE_ROUTER_05_MAIN_SUBNET_ID
  PRIVATE_IP     = local.SPOKE_ROUTER_05_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router_common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../router/spoke-router5/initial_setup-01.sh"

  tags = var.tags
}
