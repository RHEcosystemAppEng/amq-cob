output "ami_id" {
  value = local.REGION_N_AMI[var.REGION].ami_id
}

output "ami_name" {
  value = local.REGION_N_AMI[var.REGION].ami_name
}

output "region" {
  value = var.REGION
}
