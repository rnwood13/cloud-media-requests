resource "aws_iam_role" "media_requests_host" {
  name = "Media-Requests-Host-Role"

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

# S3 backup and restore SQLite DB
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
  role       = aws_iam_role.media_requests_host.name
  policy_arn = aws_iam_policy.media_requests_backup_restore.arn
}

resource "aws_iam_instance_profile" "media_requests_host" {
  name = "Media-Requests-Host-Instance-Profile"
  role = aws_iam_role.media_requests_host.name
}

# CloudWatch Agent
data "aws_iam_policy_document" "cloudwatch_agent_put_logs_retention" {
  statement {
    sid = "1"

    actions = ["logs:PutRetentionPolicy"]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_agent_put_logs_retention" {
  count  = var.cloudwatch_enable ? 1 : 0
  name   = "WoodyBox-CloudWatchAgentPutLogsRetention"
  path   = "/"
  policy = data.aws_iam_policy_document.cloudwatch_agent_put_logs_retention.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_put_logs_retention" {
  count      = var.cloudwatch_enable ? 1 : 0
  role       = aws_iam_role.media_requests_host.name
  policy_arn = aws_iam_policy.cloudwatch_agent_put_logs_retention[0].arn
}

data "aws_iam_policy" "cloudwatch_agent_server_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  count      = var.cloudwatch_enable ? 1 : 0
  role       = aws_iam_role.media_requests_host.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent_server_policy.arn
}
