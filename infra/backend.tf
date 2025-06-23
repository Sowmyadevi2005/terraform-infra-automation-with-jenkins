terraform {
  backend "s3" {
    bucket = "python-flask-app-state-bucket"
    key    = "application/terraform.tfstate"
    region = "us-east-1"
  }
}