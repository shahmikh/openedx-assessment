resource "aws_efs_file_system" "this" {
  creation_token = var.name
  encrypted      = true

  tags = var.tags
}

resource "aws_efs_mount_target" "this" {
  for_each       = toset(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = each.value
  security_groups = [var.sg_id]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
  root_directory {
    path = "/openedx"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }

  tags = var.tags
}
