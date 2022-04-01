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

variable "vpc_database_subnets" {
  type    = list(string)
  default = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
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

variable "host_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "media_request_database_type" {
  description = "The type of DB for Ombi. Can be either 'sqlite' or 'mariadb'."
  type        = string
  default     = "mariadb"
}

variable "media_request_database_size" {
  description = "The DB instance size if 'media_request_database_type' is set to 'mariadb'."
  type        = string
  default     = "db.t4g.micro"
}
