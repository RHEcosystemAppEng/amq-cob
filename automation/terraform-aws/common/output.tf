
#output "region" {
#  value = var.REGION
#}

output "vpc" {
  value = aws_vpc.main
}

output "vpc_name" {
  value = aws_vpc.main.tags.Name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "zone1_cidr" {
  value = aws_subnet.all["0"].cidr_block
}

output "zone2_cidr" {
  value = aws_subnet.all["1"].cidr_block
}

output "zone3_cidr" {
  value = aws_subnet.all["2"].cidr_block
}

output "zone1" {
  value = aws_subnet.all["0"].availability_zone
}

output "zone2" {
  value = aws_subnet.all["1"].availability_zone
}

output "zone3" {
  value = aws_subnet.all["2"].availability_zone
}

output "custom_sg_1_id" {
  value = aws_security_group.ping_ssh.id
}

output "custom_sg_1_name" {
  value = aws_security_group.ping_ssh.name
}

output "custom_sg_2_id" {
  value = aws_security_group.amq_broker.id
}

output "custom_sg_2_name" {
  value = aws_security_group.amq_broker.name
}

output "custom_sg_3_id" {
  value = aws_security_group.amq_router.id
}

output "custom_sg_3_name" {
  value = aws_security_group.amq_router.name
}

output "subnet_1_id" {
  value = aws_subnet.all["0"].id
}

output "subnet_1_name" {
  value =aws_subnet.all["0"].tags.Name
}

output "subnet_2_id" {
  value = aws_subnet.all["1"].id
}

output "subnet_2_name" {
  value =aws_subnet.all["1"].tags.Name
}

output "subnet_3_id" {
  value = aws_subnet.all["2"].id
}

output "subnet_3_name" {
  value =aws_subnet.all["2"].tags.Name
}
