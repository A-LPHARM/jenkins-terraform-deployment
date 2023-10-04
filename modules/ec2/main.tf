resource "aws_instance" "ec2_instances" {

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

 vpc_security_group_ids = [
    var.webserver-secgrp
  ]

  tags = {
    Name = "henry-ec2instance"
  }
}

resource "aws_instance" "ec2_instances2" {

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

 vpc_security_group_ids = [
    var.webserver-secgrp
  ]

  tags = {
    Name = "henry-ec2instance"
  }
}

