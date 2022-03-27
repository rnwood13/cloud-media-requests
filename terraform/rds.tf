# Generate the master password first and store in Parameter Store. You
# could also use Secrets Manager to generate and store it it for you, 
# but it is more expensive
resource "aws_db_instance" "mariadb" {
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t4g.micro"
  name                   = "${lower(var.project_name)}mariadb"
  identifier             = "${lower(var.project_name)}-mariadb"
  username               = "root"
  password               = data.aws_ssm_parameter.rds_password.value
  parameter_group_name   = "default.mariadb10.6"
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.sg_maria_db_rds.security_group_id]
  skip_final_snapshot    = true
  allocated_storage      = 20
  max_allocated_storage  = 40
}

# Store the RDS endpoint in Parameter Store for Ansible to use
resource "aws_ssm_parameter" "mariadb_endpoint" {
  name        = "/woodybox/media-requests/rds-mariadb-endpoint"
  description = "The endpoint for Ombi to connect to RDS"
  type        = "String"
  value       = aws_db_instance.mariadb.address

  tags = {
    Component = "Media Requests"
  }
}
