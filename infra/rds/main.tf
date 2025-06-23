
resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_groups # replace with your private subnet IDs
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  db_name              = var.mysql_dbname
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  identifier           = var.mysql_db_identifier
  username             = var.mysql_username
  password             = var.mysql_password
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.rds_mysql_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnet_group.name
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
}

output "db_endpoint" {
  value = aws_db_instance.default.address
}
