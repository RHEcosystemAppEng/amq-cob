resource "aws_instance" "main" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.SSH_KEY
  private_ip    = var.PRIVATE_IP

  #  for_each = aws_subnet.all
  subnet_id              = var.SUBNET_ID      // aws_subnet.all["0"].id
  vpc_security_group_ids = var.SECURITY_GROUP_IDS
  // [aws_security_group.ingress-all.id, aws_security_group.ssh.id, aws_default_security_group.default_sg.id]

  tags = merge(
    var.TAGS,
    {
      Name : var.INSTANCE_NAME
    }
  )
}
