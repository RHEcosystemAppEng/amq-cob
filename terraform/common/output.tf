
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

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "zone_cidrs" {
  value = aws_subnet.all.*.cidr_block
}

output "zones" {
  value = aws_subnet.all.*.availability_zone
}

output "security_group_default_id" {
  value = aws_default_security_group.default.id
}

output "security_group_default_name" {
  value = aws_default_security_group.default.name
}

output "security_group_ping_ssh_id" {
  value = aws_security_group.ping_ssh.id
}

output "security_group_ping_ssh_name" {
  value = aws_security_group.ping_ssh.name
}

output "security_group_amq_broker_id" {
  value = aws_security_group.amq_broker.id
}

output "security_group_amq_broker_name" {
  value = aws_security_group.amq_broker.name
}

output "security_group_amq_router_id" {
  value = aws_security_group.amq_router.id
}

output "security_group_amq_router_name" {
  value = aws_security_group.amq_router.name
}

output "subnet_ids" {
  value = aws_subnet.all.*.id
}

output "subnet_names" {
  value = aws_subnet.all.*.tags.Name
}

output "subnets" {
  value = aws_subnet.all
}

output "route_table-main-id" {
  value = aws_route_table.main.id
}

output "route_table-default-id" {
  value = aws_default_route_table.main.id
}

output "efs_fs_id" {
  value = aws_efs_file_system.efs_fs.id
}

output "efs_fs_dns" {
  value = aws_efs_file_system.efs_fs.dns_name
}
