output "key" {
  value = var.ibmcloud_api_key
}

output "region" {
  value = var.REGION
}

output "vpc" {
  value = ibm_is_vpc.amq_vpc
}

output "vpc_name" {
  value = ibm_is_vpc.amq_vpc.name
}

output "vpc_id" {
  value = ibm_is_vpc.amq_vpc.id
}

output "zone1" {
  value = ibm_is_subnet.amq_subnet_01.zone
}

output "zone2" {
  value = ibm_is_subnet.amq_subnet_02.zone
}

output "zone3" {
  value = ibm_is_subnet.amq_subnet_03.zone
}

output "zone1_cidr" {
  value = ibm_is_subnet.amq_subnet_01.ipv4_cidr_block
}

output "zone2_cidr" {
  value = ibm_is_subnet.amq_subnet_02.ipv4_cidr_block
}

output "zone3_cidr" {
  value = ibm_is_subnet.amq_subnet_03.ipv4_cidr_block
}

output "default_vpc_sg" {
  value = ibm_is_vpc.amq_vpc.default_security_group
}

output "custom_sg_1_id" {
  value = ibm_is_security_group.amq_sec_grp_01.id
}

output "custom_sg_1_name" {
  value = ibm_is_security_group.amq_sec_grp_01.name
}

output "custom_sg_2_id" {
  value = ibm_is_security_group.amq_sec_grp_02.id
}

output "custom_sg_2_name" {
  value = ibm_is_security_group.amq_sec_grp_02.name
}

output "subnet_1_id" {
  value = ibm_is_subnet.amq_subnet_01.id
}

output "subnet_1_name" {
  value = ibm_is_subnet.amq_subnet_01.name
}

output "subnet_2_id" {
  value = ibm_is_subnet.amq_subnet_02.id
}

output "subnet_2_name" {
  value = ibm_is_subnet.amq_subnet_02.name
}

output "subnet_3_id" {
  value = ibm_is_subnet.amq_subnet_03.id
}

output "subnet_3_name" {
  value = ibm_is_subnet.amq_subnet_03.name
}
