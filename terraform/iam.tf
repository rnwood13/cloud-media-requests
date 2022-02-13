resource "aws_iam_role" "media_requests_backup_restore" {
  name = "Media-Requests-Backup-Restore-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "media_requests_backup_restore" {
  statement {
    sid = "1"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${data.aws_ssm_parameter.mr_db_backup_bucket_name.value}",
      "arn:aws:s3:::${data.aws_ssm_parameter.mr_db_backup_bucket_name.value}/Ombi.db",
      "arn:aws:s3:::${data.aws_ssm_parameter.mr_db_backup_bucket_name.value}/OmbiExternal.db",
      "arn:aws:s3:::${data.aws_ssm_parameter.mr_db_backup_bucket_name.value}/OmbiSettings.db"
    ]
  }
}

resource "aws_iam_policy" "media_requests_backup_restore" {
  name   = "Media-Requests-Backup-Restore-Policy"
  path   = "/"
  policy = data.aws_iam_policy_document.media_requests_backup_restore.json
}

resource "aws_iam_role_policy_attachment" "media_requests_backup_restore" {
  role       = aws_iam_role.media_requests_backup_restore.name
  policy_arn = aws_iam_policy.media_requests_backup_restore.arn
}

resource "aws_iam_instance_profile" "media_requests_backup_restore" {
  name = "Media-Requests-Backup-Restore-Instance-Profile"
  role = aws_iam_role.media_requests_backup_restore.name
}
