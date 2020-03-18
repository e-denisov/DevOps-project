provider "aws" {
    region = "eu-west-3"
}

resource "aws_instance" "Ubuntu-Terraform" {
    ami = "ami-051ebe9615b416c15"
    instance_type = "t2.micro"
    tags = {
    name = "Terraform"
    owner = "Hits"
    project = "DevOps-CI/CD"
    }
    key_name = "denisovich-key-Paris"
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    user_data = <<EOF
#!/bin/bash
sudo apt update
wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip
sudo apt install unzip -y
unzip terraform_0.12.23_linux_amd64.zip
rm terraform_0.12.23_linux_amd64.zip
sudo mv terraform /bin/
sudo mkdir /home/ubuntu/terraform
sudo chgrp -R ubuntu /home/ubuntu/terraform
sudo chmod -R g+rw /home/ubuntu/terraform
mkdir /home/ubuntu/terraform/webservers
mkdir /home/ubuntu/terraform/apache
mkdir /home/ubuntu/terraform/nginx
mkdir /home/ubuntu/terraform/jenkins
EOF
}

resource "aws_security_group" "allow_ssh" {
  name        = "SSH security group"
  description = "security group for ssh"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "SSH security group"
  }
}
