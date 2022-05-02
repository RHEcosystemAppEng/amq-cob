output "ami_id" {
  value = var.AMI_ID
}

output "ami_name" {
  value = var.AMI_NAME
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "host_id" {
  value = aws_instance.main.host_id
}

output "instance_name" {
  value = aws_instance.main.tags.Name
}
