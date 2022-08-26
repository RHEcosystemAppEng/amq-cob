locals {
  REGION = var.REGION

  SEC_GRP_DEFAULT_ID   = module.common.security_group_default_id
  SEC_GRP_PING_SSH_ID   = module.common.security_group_ping_ssh_id
  SEC_GRP_AMQ_BROKER_ID = module.common.security_group_amq_broker_id
  SEC_GRP_AMQ_ROUTER_ID = module.common.security_group_amq_router_id

  BROKER_SECURITY_GROUP_IDS = [local.SEC_GRP_PING_SSH_ID, local.SEC_GRP_AMQ_BROKER_ID, local.SEC_GRP_DEFAULT_ID]

  // Map to point to the two zones and corresponding subnets (Subnet should match zone)
  ZONE_N_SUBNET = {
    "1" : { zone : module.common.subnets["0"].availability_zone, subnet: module.common.subnets["0"].id }
    "2" : { zone : module.common.subnets["1"].availability_zone, subnet: module.common.subnets["1"].id }
  }

  NFS_SUFFIX         = var.INSTANCE_INFO[var.KEY_NFS].suffix
  NFS_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_NFS].private_ip
  NFS_MAIN_ZONE      = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_NFS].main_zone].zone
  NFS_MAIN_SUBNET_ID = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_NFS].main_zone].subnet

  BROKER_01_SUFFIX         = var.INSTANCE_INFO[var.KEY_BROKER_01].suffix
  BROKER_01_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_BROKER_01].private_ip
  BROKER_01_MAIN_ZONE      = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_01].main_zone].zone
  BROKER_01_MAIN_SUBNET_ID = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_01].main_zone].subnet

  BROKER_02_SUFFIX         = var.INSTANCE_INFO[var.KEY_BROKER_02].suffix
  BROKER_02_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_BROKER_02].private_ip
  BROKER_02_MAIN_ZONE      = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_02].main_zone].zone
  BROKER_02_MAIN_SUBNET_ID = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_02].main_zone].subnet

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

  BROKER_03_SUFFIX         = var.INSTANCE_INFO[var.KEY_BROKER_03].suffix
  BROKER_03_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_BROKER_03].private_ip
  BROKER_03_MAIN_ZONE      = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_03].main_zone].zone
  BROKER_03_MAIN_SUBNET_ID = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_03].main_zone].subnet

  BROKER_04_SUFFIX         = var.INSTANCE_INFO[var.KEY_BROKER_04].suffix
  BROKER_04_PRIVATE_IP     = var.INSTANCE_INFO[var.KEY_BROKER_04].private_ip
  BROKER_04_MAIN_ZONE      = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_04].main_zone].zone
  BROKER_04_MAIN_SUBNET_ID = local.ZONE_N_SUBNET[var.INSTANCE_INFO[var.KEY_BROKER_04].main_zone].subnet


}
