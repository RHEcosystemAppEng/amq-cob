locals {
  REGION = var.REGION

  SEC_GRP_DEFAULT_ID   = module.common.security_group_default_id
  SEC_GRP_PING_SSH_ID   = module.common.security_group_ping_ssh_id
  SEC_GRP_AMQ_BROKER_ID = module.common.security_group_amq_broker_id
  SEC_GRP_AMQ_ROUTER_ID = module.common.security_group_amq_router_id

  BROKER_SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_AMQ_BROKER_ID, local.SEC_GRP_DEFAULT_ID]
  ROUTER_SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_AMQ_BROKER_ID, local.SEC_GRP_AMQ_ROUTER_ID, local.SEC_GRP_DEFAULT_ID]

  NFS_SUFFIX         = "nfs-server"
  NFS_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.50"
  NFS_MAIN_ZONE      = module.common.zone1
  NFS_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_01_SUFFIX         = "broker01-live1"
  BROKER_01_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.51"
  BROKER_01_MAIN_ZONE      = module.common.zone1
  BROKER_01_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  BROKER_02_SUFFIX         = "broker02-bak1"
  BROKER_02_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.51"
  BROKER_02_MAIN_ZONE      = module.common.zone2
  BROKER_02_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  # Using same zone/subnet as bak01 for the medium (or large) instance is not supported in zone3. Running with zone3 gives me following error:
  /*
    │ Error: Error launching source instance: Unsupported: Your requested instance type (t2.medium) is not supported in your requested Availability Zone (ca-central-1d).
    │        Please retry your request by not specifying an Availability Zone or choosing ca-central-1a, ca-central-1b.
    │        status code: 400, request id: 3c504543-578a-45c0-a536-f87ce4fa061d

    │ Error: Error launching source instance: Unsupported: Your requested instance type (t2.large) is not supported in your requested Availability Zone (ca-central-1d).
    │        Please retry your request by not specifying an Availability Zone or choosing ca-central-1a, ca-central-1b.
    │        status code: 400, request id: 5c256f03-c91c-4a4d-ad59-5c2f400cea14
    │
  */

  BROKER_03_SUFFIX         = "broker03-live2"
  BROKER_03_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.52"
  BROKER_03_MAIN_ZONE      = module.common.zone2
  BROKER_03_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  BROKER_04_SUFFIX         = "broker04-bak2"
  BROKER_04_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.52"
  BROKER_04_MAIN_ZONE      = module.common.zone1
  BROKER_04_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  HUB_ROUTER_01_SUFFIX         = "hub-router1"
  HUB_ROUTER_01_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.1}.100"
  HUB_ROUTER_01_MAIN_ZONE      = module.common.zone2
  HUB_ROUTER_01_MAIN_SUBNET_ID = module.common.subnet_2_id # Subnet should match zone

  SPOKE_ROUTER_02_SUFFIX         = "spoke-router2"
  SPOKE_ROUTER_02_PRIVATE_IP     = "${var.IP_NUMBER_PREFIX.0}.101"
  SPOKE_ROUTER_02_MAIN_ZONE      = module.common.zone1
  SPOKE_ROUTER_02_MAIN_SUBNET_ID = module.common.subnet_1_id # Subnet should match zone

  tags = merge(
    var.TAGS,
    {
      Cluster : "cluster: 1"
    }
  )
}
