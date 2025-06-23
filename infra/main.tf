module "networking" {
  source              = "./networking"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone   = var.availability_zone
  private_subnet_cidr = var.private_subnet_cidr
}

module "security_group" {
  source                     = "./security-groups"
  ec2_sg_name                = "SG for EC2 to enable SSH(22) and HTTP(80)"
  vpc_id                     = module.networking.vpc_id
  public_subnet_cidr_block   = tolist(module.networking.public_subnets_cidr)
  ec2_sg_name_for_python_api = "SG for EC2 for enabling port 5000"
}

module "rds_db_instance" {
  source               = "./rds"
  db_subnet_group_name = "flask_app_rds_subnet_group"
  subnet_groups        = tolist(module.networking.public_subnets)
  rds_mysql_sg_id      = module.security_group.rds_mysql_sg_id
  mysql_db_identifier  = "mydb"
  mysql_username       = var.mysql_username
  mysql_password       = var.mysql_password
  mysql_dbname         = var.mysql_dbname
}
module "ec2" {
  source                     = "./ec2"
  ami_id                     = var.ec2_ami_id
  instance_type              = "t2.micro"
  tag_name                   = "Ubuntu Linux EC2"
  public_key                 = file("${path.module}/keys/id_rsa.pub")
  subnet_id                  = tolist(module.networking.public_subnets)[0]
  sg_enable_ssh_https        = module.security_group.sg_ec2_sg_ssh_http_id
  ec2_sg_name_for_python_api = module.security_group.sg_ec2_for_python_api
  enable_public_ip_address   = true
  user_data_install_apache = templatefile("./ec2/ec2_install_apache.sh", {
    db_host     = module.rds_db_instance.db_endpoint
    db_user     = var.mysql_username
    db_password = var.mysql_password
    db_name     = var.mysql_dbname
  })
}

module "alb" {
  source                   = "./load-balancer"
  lb_target_group_name     = "app-lb-target-group"
  lb_target_group_port     = 5000
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.vpc_id
  ec2_instance_id          = module.ec2.ec2_appserver_id


  lb_name                    = "flak-app-lb"
  is_external                = false
  lb_type                    = "application"
  sg_enable_ssh_https        = module.security_group.sg_ec2_sg_ssh_http_id
  subnet_ids                 = tolist(module.networking.public_subnets)
  lb_listener_port           = 5000
  lb_listener_protocol       = "HTTP"
  lb_listener_default_action = "forward"
  lb_https_listener_port     = 443
  lb_https_listener_protocol = "HTTPS"
  flask_mysql_app_acm_arn    = module.aws_ceritification_manager.domain_acm_arn


}

module "hosted_zone" {
  source          = "./hosted_zone"
  domain_name     = var.domain_name
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "aws_ceritification_manager" {
  source         = "./certificate-manager"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}

