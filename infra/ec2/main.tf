



resource "aws_instance" "ec2_appserver" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_key"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_enable_ssh_https, var.ec2_sg_name_for_python_api]
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_apache

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "app_server_public_key" {
  key_name   = "aws_key"
  public_key = var.public_key
}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /home/ubuntu/keys/aws_ec2_terraform ubuntu@", aws_instance.ec2_appserver.public_ip)
}

output "ec2_appserver_id" {
  value = aws_instance.ec2_appserver.id
}