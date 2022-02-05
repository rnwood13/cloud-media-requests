packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "project_name" {
  type    = string
  default = "cloud-media-requests"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "amzn2-docker" {
  ami_name                = "${lower(var.project_name)}-docker-${local.timestamp}"
  ami_description         = "Amazon Linux 2 host with Docker and Docker Compose"
  instance_type           = "t3.micro"
  region                  = "${var.region}"
  ami_virtualization_type = "hvm"
  ssh_username            = "ec2-user"
  ssh_timeout             = "1h"
  ebs_optimized           = true
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  tags = {
    Name          = "${var.project_name} Docker Host"
    OS_Version    = "Amazon Linux 2"
    Base_AMI_ID   = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Project       = "${var.project_name}"
  }
}


build {
  name = "amzn2-docker"
  sources = [
    "source.amazon-ebs.amzn2-docker"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Installing Docker",
      "sleep 10",
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Docker Compose",
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing git",
      "sudo yum install git -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing Wireguard",
      "sudo amazon-linux-extras install -y epel",
      "sudo curl -L -o /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo",
      "sudo yum install -y wireguard-dkms wireguard-tools",
      "sudo mkdir -p /etc/wireguard",
      "sudo systemctl enable wg-quick@wg0.service"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo Installing boto3",
      "python3 -m pip install boto3 --user"
    ]
  }
}
