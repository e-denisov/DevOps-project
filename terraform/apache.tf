provider "aws" {
    region = "eu-west-3"
}

resource "aws_instance" "my_Ubuntu" {
  ami = "ami-051ebe9615b416c15"
  instance_type = "t2.micro"
  tags = {
  name = "Apache"
  owner = "Hits"
  project = "DevOps-CI/CD"
  }
  key_name = "denisovich-key-Paris"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo chgrp -R ubuntu /var/www
sudo chmod -R g+rw /var/www
EOF
}


resource "aws_security_group" "allow_ssh_http_https" {
  name        = "WebServers security group"
  description = "security group for web servers ssh_http_https"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "web"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web security group"
  }
}
