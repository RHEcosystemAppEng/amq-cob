
module "toronto" {
  source = "./common"

  providers = {
    ibm = ibm.tor
  }
  ibmcloud_api_key = var.ibmcloud_api_key

  INSTANCE_NAMES = local.region_1_instance_names
  PREFIX = var.PREFIX
  REGION = var.REGION_1
  INSTANCE_ACTION = var.INSTANCE_ACTION
  FORCE_ACTION = var.FORCE_ACTION
}

module "dallas" {
  source = "./common"

  providers = {
    ibm = ibm
  }
  ibmcloud_api_key = var.ibmcloud_api_key

  INSTANCE_NAMES = local.region_2_instance_names
  PREFIX = var.PREFIX
  REGION = var.REGION_2
  INSTANCE_ACTION = var.INSTANCE_ACTION
  FORCE_ACTION = var.FORCE_ACTION
}