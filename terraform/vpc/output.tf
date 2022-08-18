
output "prefix" {
  value = var.PREFIX
}

output "region" {
  value = local.REGION
}

output "ami_id" {
  value = var.AMI_ID
}

output "ami_name" {
  value = var.AMI_NAME
}

output "zone_n_subnet_map" {
  value = local.ZONE_N_SUBNET
}

output "vpc_common" {
  value = module.common
}

output "nfs-server-output" {
  value = module.nfs-server
}

output "broker01-output" {
  value = module.broker-01-live
}

output "broker02-bak-output" {
  value = module.broker-02-bak
}

output "broker03-live-output" {
  value = module.broker-03-live
}

output "broker04-bak-output" {
  value = module.broker-04-bak
}
