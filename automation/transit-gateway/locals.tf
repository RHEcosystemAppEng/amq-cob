locals {
  DAL_REGION = var.dallas_regions_zones.region
  TOR_REGION = var.toronto_regions_zones.region

  DAL_ZONE = var.dallas_regions_zones.zones.dal1
  TOR_ZONE = var.toronto_regions_zones.zones.tor1

  NETWORK_TYPE_VPC = "vpc"
}