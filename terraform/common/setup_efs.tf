
resource "aws_efs_file_system" "efs_fs" {
  performance_mode = "maxIO"
  tags = var.TAGS
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = aws_efs_file_system.efs_fs.id

  # Limiting to 3 max as we don't have the static value to set (in the given map) for 4th entry
  count = length(data.aws_availability_zones.zones.names) <= 2 ? length(data.aws_availability_zones.zones.names) : 2

  subnet_id = aws_subnet.all[tostring(count.index)].id
}
