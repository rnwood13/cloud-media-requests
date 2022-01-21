variable "project_name" {
  type    = string
  default = "MyProject"
}

variable "vpc_name" {
  type    = string
  default = "MyVPC"
}

variable "vpc_region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_enable_nat_gateway" {
  type    = bool
  default = false
}

variable "vpc_enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "host_enable" {
  type    = bool
  default = true
}
