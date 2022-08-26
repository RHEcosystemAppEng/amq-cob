module "common" {
  source = "../common"

  providers = {
    aws = aws
  }

  CIDR_BLOCKS = {
    "0" : { cidr : "${var.IP_NUMBER_PREFIX.0}.0/24" }  # 255 addresses for 1st AZ
    "1" : { cidr : "${var.IP_NUMBER_PREFIX.1}.0/24" }  # 255 addresses for 2nd AZ
    "2" : { cidr : "${var.IP_NUMBER_PREFIX.2}.0/24" }  # 255 addresses for 3rd AZ
    "3" : { cidr : "${var.IP_NUMBER_PREFIX.2}.0/24" }  # 255 addresses for 3rd AZ
  }

  MAIN_CIDR_BLOCK = var.MAIN_CIDR_BLOCK
  NAME_PREFIX     = var.NAME_PREFIX

  TAGS = merge(
    var.TAGS,
    {
      Setup : "common"
    }
  )
}

module "nfs-server" {
  source = "../instance"

  providers = {
    aws = aws
  }

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP         = local.NFS_PRIVATE_IP
  SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_DEFAULT_ID]

  TAGS = merge(
    var.TAGS,
    {
      Setup : "NFS server"
    }
  )
}

module "broker-01-live" {
  source = "../instance"

  providers = {
    aws = aws
  }

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_01_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_01_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_01_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Broker : "Live 01"
      Setup : "amq_broker"
    }
  )
}

module "broker-02-bak" {
  source = "../instance"

  providers = {
    aws = aws
  }

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_02_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_02_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_02_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Broker : "Bak 01"
      Setup : "amq_broker"
    }
  )
}

module "broker-03-live" {
  source = "../instance"

  providers = {
    aws = aws
  }

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_03_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_03_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_03_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Broker : "Live 02"
      Setup : "amq_broker"
    }
  )
}

module "broker-04-bak" {
  source = "../instance"

  providers = {
    aws = aws
  }

  SSH_KEY       = var.SSH_KEY
  INSTANCE_NAME = "${var.NAME_PREFIX}-${local.BROKER_04_SUFFIX}"

  AMI_ID             = var.AMI_ID
  AMI_NAME           = var.AMI_NAME
  INSTANCE_TYPE      = var.INSTANCE_TYPE
  SUBNET_ID          = local.BROKER_04_MAIN_SUBNET_ID
  PRIVATE_IP         = local.BROKER_04_PRIVATE_IP
  SECURITY_GROUP_IDS = local.BROKER_SECURITY_GROUP_IDS

  TAGS = merge(
    var.TAGS,
    {
      Broker : "Bak 02"
      Setup : "amq_broker"
    }
  )
}
