resource "aws_instance" "main" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.SSH_KEY
  private_ip    = var.PRIVATE_IP

  subnet_id              = var.SUBNET_ID
  vpc_security_group_ids = var.SECURITY_GROUP_IDS

  tags = merge(
    var.TAGS,
    {
      Name : var.INSTANCE_NAME
    }
  )
}
