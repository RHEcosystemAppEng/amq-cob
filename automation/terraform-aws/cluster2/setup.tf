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

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-01"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP         = local.NFS_PRIVATE_IP
  SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_DEFAULT_ID]

  TAGS = merge(
    local.tags,
    {
      Setup : "NFS server"
    }
  )
}

module "broker-01-live" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_01_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_01_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_01_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Live 03"
      Setup : "amq_broker"
    }
  )
}

module "broker-02-bak" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_02_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_02_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_02_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Bak 03"
      Setup : "amq_broker"
    }
  )
}

module "broker-03-live" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_03_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_03_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_03_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Live 04"
      Setup : "amq_broker"
    }
  )
}

module "broker-04-bak" {
  source = "../instance"

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_04_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_04_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_04_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    local.tags,
    {
      Broker : "Bak 04"
      Setup : "amq_broker"
    }
  )
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
    local.tags,
    {
      Router : "Spoke 02"
      Setup : "amq_router"
    }
  )
}
