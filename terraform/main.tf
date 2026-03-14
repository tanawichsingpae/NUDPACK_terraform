provider "aws" {
  region = var.aws_region
}

# Generate SSH key
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# Security group
resource "aws_security_group" "app_sg" {
  name = "nudpack-sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "FastAPI"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "nudpack_server" {

  ami           = "ami-0df7a207adb9748c7"
  instance_type = var.instance_type

  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<EOF
#!/bin/bash

set -e

echo "START USER DATA" >> /home/ubuntu/deploy.log

apt-get update -y
apt-get install -y python3 python3-pip python3-venv git

cd /home/ubuntu

git clone ${var.github_repo}

REPO_DIR=$(basename ${var.github_repo} .git)

cd $REPO_DIR

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

echo "DEPENDENCIES INSTALLED" >> /home/ubuntu/deploy.log

# Neon database connection
export DATABASE_URL="postgresql://neondb_owner:npg_Zhfo7z0HPVqx@ep-crimson-math-a1roetu2-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

sleep 3

echo "STARTING FASTAPI" >> /home/ubuntu/deploy.log

nohup python3 -m uvicorn server.app.api:app --host 0.0.0.0 --port 8000 > /home/ubuntu/app.log 2>&1 &

echo "FASTAPI STARTED" >> /home/ubuntu/deploy.log

EOF

  user_data_replace_on_change = true

  tags = {
    Name = "nudpack-server"
  }
}