module "sg_host_inbound_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${var.project_name}-SSH-Inbound"
  description = "Security group to allow inbound SSH"
  vpc_id      = module.vpc.vpc_id

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

  tags = {
    Usage = "Inbound SSH for Media Requests Management"
  }
}

module "sg_host_inbound_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${var.project_name}-Web-Inbound"
  description = "Security group to allow inbound web traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow inbound HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow inbound HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Usage = "Inbound web traffic for Media Requests Management"
  }
}

module "sg_maria_db_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${var.project_name}-MariaDB-RDS"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Mariadb Access from within the VPC"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Usage = "Allow access to mariadb RDS"
  }
}
