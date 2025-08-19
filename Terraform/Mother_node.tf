provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "webapp" {
  count        = 1
  ami           = var.ami
  instance_type = "t3.medium"
  vpc_security_group_ids = [aws_security_group.webapp-secret_Group.id]

  tags = {
    Name = "ostad_webApp"
  }
}


resource "aws_security_group" "webapp-secret_Group" {
  name        = "allow_http"
  description = "Allow SSH, HTTP, HTTPS, and NodePort access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # For Minikube NodePort services
  ingress {
    from_port   = 30000
    to_port     = 32767
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


output "public_ip" {
  value = aws_instance.ostad_webApp.public_ip
}
