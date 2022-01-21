# I'm using Parameter Store to obfuscate
# certain values for my own privacy.
# This section assumes that the parameters have
# already been setup in AWS Parameter Store
# and are using appropriate values.

data "aws_ssm_parameter" "ssh_cidrs" {
  name = "${var.project_name}-SSH-CIDRs"
}

data "aws_ssm_parameter" "key_pair_name" {
  name = "${var.project_name}-Key-Pair-Name"
}

data "aws_key_pair" "main" {
  key_name = data.aws_ssm_parameter.key_pair_name.value
}
