# Generate the master password first and store in Parameter Store. You
# could also use Secrets Manager to generate and store it it for you, 
# but it is more expensive
resource "aws_db_instance" "mariadb" {
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = var.media_request_database_size
  name                   = "${lower(var.project_name)}mariadb"
  identifier             = "${lower(var.project_name)}-mariadb"
  username               = "root"
  password               = data.aws_ssm_parameter.rds_password.value
  parameter_group_name   = aws_db_parameter_group.mariadb.name
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.sg_maria_db_rds.security_group_id]
  skip_final_snapshot    = true
  allocated_storage      = 20
  max_allocated_storage  = 40
}

resource "aws_db_parameter_group" "mariadb" {
  name   = "${lower(var.project_name)}-mariadb-parameter-group"
  family = "mariadb10.6"

  parameter {
    name  = "max_connections"
    value = "200"
  }
}

# Store the RDS endpoint in Parameter Store for Ansible to use
resource "aws_ssm_parameter" "mariadb_endpoint" {
  name        = "/${lower(var.project_name)}/media-requests/rds-mariadb-endpoint"
  description = "The endpoint for Ombi to connect to RDS"
  type        = "String"
  value       = aws_db_instance.mariadb.address

  tags = {
    Component = "Media Requests"
  }
}
