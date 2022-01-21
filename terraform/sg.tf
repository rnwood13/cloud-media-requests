module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${var.project_name}-SSH"
  description = "Security group to allow inbound SSH"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks = split(",", data.aws_ssm_parameter.ssh_cidrs.value)
  # ingress_rules       = ["ssh-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow inbound SSH"
      cidr_blocks = data.aws_ssm_parameter.ssh_cidrs.value
    }
  ]

  egress_rules = ["all-all"]
}
