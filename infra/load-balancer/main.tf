/*
# python(flask)-mysql  Application Load Balancer (ALB) Setup Using Terraform

This script provisions:
- An Application Load Balancer (ALB) for Python App
- A Target Group with health checks on `/health`
- Listener rules for HTTP and HTTPS
- Target Group attachments to forward traffic to the EC2 instance
- Outputs for ALB DNS, Zone ID, and Target Group ARN
*/

# Create Target Group for application EC2
resource "aws_lb_target_group" "app_lb_target_group" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    port                = 5000
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

# Attach EC2 instance to the target group
resource "aws_lb_target_group_attachment" "app_target_attachment" {
  target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  target_id        = var.ec2_instance_id
  port             = var.lb_target_group_port
}

# Create an Application Load Balancer for application server
resource "aws_lb" "app_lb" {
  name                       = var.lb_name
  internal                   = var.is_external
  load_balancer_type         = var.lb_type
  security_groups            = [var.sg_enable_ssh_https]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "flask-mysql-lb"
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.lb_https_listener_port
  protocol          = var.lb_https_listener_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.flask_mysql_app_acm_arn

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}

# HTTP Listener (optional)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = var.lb_listener_default_action
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}

# Outputs
output "app_lb_target_group_arn" {
  value = aws_lb_target_group.app_lb_target_group.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.app_lb.zone_id
}
