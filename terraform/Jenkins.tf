provider "aws" {
    region = "eu-west-3"
}

resource "aws_instance" "Ubuntu-Jenkins" {
  ami = "ami-051ebe9615b416c15"
  instance_type = "t2.micro"
  tags = {
  name = "Jenkins"
  owner = "Hits"
  project = "DevOps-CI/CD"
  }
  key_name = "denisovich-key-Paris"
  vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]
  user_data = <<EOF
#!/bin/bash
sudo apt update
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt update
sudo apt install openjdk-8-jre-headless -y
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ubuntu/jenkins-key
EOF
}

resource "aws_security_group" "allow_ssh_tcp" {
  name        = "Jenkins security group"
  description = "security group for Jenkins ssh_tcp"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jenkins"
    from_port   = 8080
    to_port     = 8080
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
    Name = "Jenkins security group"
  }
}