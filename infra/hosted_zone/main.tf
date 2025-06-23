/*
Terraform Script: Route53 DNS Record for ALB

Description:
This Terraform script creates a public Route53 "A" record that maps a subdomain (e.g., jenkins.builddeployscale.xyz) to an AWS Application Load Balancer (ALB) using an alias. This enables you to access your application hosted on an ALB using a custom domain.

Inputs:
- var.domain_name       → The subdomain to point (e.g., jenkins.builddeployscale.xyz)
- var.aws_lb_dns_name   → The DNS name of the ALB (from aws_lb resource)
- var.aws_lb_zone_id    → The hosted zone ID of the ALB (for alias routing)

Outputs:
- hosted_zone_id        → The ID of the Route53 hosted zone for reference or chaining

Prerequisite:
- A public hosted zone must exist in Route53 for the base domain (e.g., builddeployscale.xyz).
*/


#==============================
# Variables
#==============================
variable "domain_name" {}
variable "aws_lb_dns_name" {}
variable "aws_lb_zone_id" {}


#==============================
# Data Source: Fetch Route53 Hosted Zone
#==============================
data "aws_route53_zone" "deployscale" {
  name         = var.domain_name #  registered domain
  private_zone = false           # Only look for public hosted zone
}
#==============================
# Resource: Route53 Record (A - Alias)
#==============================
resource "aws_route53_record" "lb_record" {
  zone_id = data.aws_route53_zone.deployscale.zone_id # Use the hosted zone of the base domain
  name    = var.domain_name                           # Full subdomain (e.g., jenkins.builddeployscale.xyz)
  type    = "A"

  alias {
    name                   = var.aws_lb_dns_name # ALB DNS name
    zone_id                = var.aws_lb_zone_id  # ALB's hosted zone ID
    evaluate_target_health = true                # Health check support
  }
}

#==============================
# Output: Hosted Zone ID
#==============================
output "hosted_zone_id" {
  value = data.aws_route53_zone.deployscale.zone_id
}
