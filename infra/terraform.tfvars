
#name        = "environment"
#environment = "dev-1"

vpc_cidr            = "10.0.0.0/16"
vpc_name            = "dev-proj-eu-central-vpc-1"
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zone   = ["us-east-1a", "us-east-1b"]


ec2_ami_id = "ami-020cba7c55df1f615"

domain_name    = "builddeployscale.xyz"
mysql_username = "dbuser"
mysql_dbname   = "devprojdb"
mysql_password = "dbpassword"
