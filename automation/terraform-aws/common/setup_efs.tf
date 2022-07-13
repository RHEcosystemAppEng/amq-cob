
# TODO(SG): make the EFS encrypted
resource "aws_efs_file_system" "efs_fs" {
  performance_mode = "maxIO"
  tags = var.TAGS
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = aws_efs_file_system.efs_fs.id

  count     = length(data.aws_availability_zones.zones.names)
  subnet_id = aws_subnet.all[tostring(count.index)].id
}
