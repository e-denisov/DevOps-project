provider "aws" {
    region = "eu-west-3"
}

resource "aws_instance" "Ubuntu-docker-nginx" {
  ami = "ami-051ebe9615b416c15"
  instance_type = "t2.micro"
  tags = {
  name = "nginx from docker-container"
  owner = "Hits"
  project = "DevOps-CI/CD"
  }
  key_name = "denisovich-key-Paris"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install apt-transport-https -y
sudo apt install curl -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mkdir /home/ubuntu/www
sudo chgrp -R ubuntu /home/ubuntu/www
sudo chmod -R g+rw /home/ubuntu/www
cd /home/ubuntu/www
touch docker-compose.yml
cat > docker-compose.yml <<TXT
version: '3.1'
services:
  nginx:
    image: nginx
    restart: always
    volumes:
      - /home/ubuntu/www:/usr/share/nginx/html
    ports:
      - 80:80
TXT
docker-compose up
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
