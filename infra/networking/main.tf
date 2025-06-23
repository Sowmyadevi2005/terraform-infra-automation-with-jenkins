/*
# Terraform VPC Infrastructure Setup for Flask application Deployment

This Terraform configuration creates a basic VPC setup in AWS (Mumbai region - ap-south-1) to host a python application infrastructure. It includes:

- A custom VPC with user-defined CIDR
- Multiple **public and private subnets** across availability zones
- An **Internet Gateway** to allow internet access for public subnets
- A **Route Table** for each of public and private subnets
- Route table associations to link subnets to the appropriate route tables

## Outputs:
- `vpc_id`: The ID of the created VPC
- `public_subnets`: List of public subnet IDs
- `public_subnets_cidr`: List of public subnet CIDR blocks
*/

#==============================
# Variables
#==============================
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "availability_zone" {}

#==============================
# Resources
#==============================
# Create a VPC with a CIDR block provided through variables
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = var.vpc_name
  }
}

# Create public subnets based on the list of CIDRs and availability zones
resource "aws_subnet" "public-subnet" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    "Name" = "flask-mysql-public-subnet-${count.index + 1}"
  }
}

# Create private subnets similarly using variables
resource "aws_subnet" "private-subnet" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    "Name" = "flask-mysql-private-subnet-${count.index + 1}"
  }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "flask-mysql-igw"
  }
}

# Create a route table for public subnets and add a route to the Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "flask-mysql-public-rt"
  }
}

# Create a private route table (no internet route included here)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "flask-mysql-private-rt"
  }
}

# Associate each public subnet with the public route table
resource "aws_route_table_association" "public_rt_association" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate each private subnet with the private route table
resource "aws_route_table_association" "private_rt_association" {
  count = length(var.private_subnet_cidr)
  subnet_id = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


#==============================
# Output: 
#==============================
# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Output all public subnet IDs
output "public_subnets" {
  value = aws_subnet.public-subnet[*].id
}

# Output all public subnet CIDR blocks
output "public_subnets_cidr" {
  value = aws_subnet.public-subnet[*].cidr_block
}
