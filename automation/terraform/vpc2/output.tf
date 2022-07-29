
output "prefix" {
  value = var.PREFIX
}

output "ami_id" {
  value = var.AMI_ID
}

output "ami_name" {
  value = var.AMI_NAME
}

output "vpc_common" {
  value = module.common.vpc_common
}

output "nfs-server-output" {
  value = module.common.nfs-server-output
}

output "broker01-live-output" {
  value = module.common.broker01-output
}

output "broker02-bak-output" {
  value = module.common.broker02-bak-output
}

output "broker03-live-output" {
  value = module.common.broker03-live-output
}

output "broker04-bak-output" {
  value = module.common.broker04-bak-output
}

output "router-03-spoke-output" {
  value = module.router-03-spoke
}
