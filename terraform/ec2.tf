data "aws_ami" "docker_host" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${lower(var.project_name)}-docker-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "docker_host" {
  # Enable or disable the instance with a variable
  count = var.host_enable ? 1 : 0

  ami                         = data.aws_ami.docker_host.id
  associate_public_ip_address = true
  instance_type               = var.host_instance_type
  key_name                    = data.aws_key_pair.main.key_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name} Docker Host"
    Task = "Servers"
  }
}
