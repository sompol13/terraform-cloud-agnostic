# Terraform configs and require provider plugins
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create a AWS Security Group
resource "aws_security_group" "sg_http" {
  name = "sg_http"
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an AWS EC2 instance
resource "aws_instance" "app_server" {
  tags                   = { Name : "app_server" }
  ami                    = "ami-042f884c037e74d76"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_http.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

# Create a AWS Security Group
resource "aws_security_group" "sg_database" {
  name = "sg_database"
  ingress {
    from_port = "5432"
    to_port   = "5432"
    protocol  = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
}

# Create a AWS RDS instance
resource "aws_db_instance" "db_server" {
  identifier             = "db-server"
  name                   = "pg_master"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.4"
  instance_class         = "db.t2.micro"
  username               = "root"
  password               = "0604e2303aa2cc3c3"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg_database.id]
}
