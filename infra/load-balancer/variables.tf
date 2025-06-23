variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_target_group_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}
variable "lb_name" {}
variable "is_external" {}
variable "lb_type" {}
variable "sg_enable_ssh_https" {}
variable "subnet_ids" {
  type = list(string)
}
variable "lb_https_listener_port" {}
variable "lb_https_listener_protocol" {}
variable "flask_mysql_app_acm_arn" {}
variable "lb_listener_default_action" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
