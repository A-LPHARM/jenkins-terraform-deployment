# variable "aws_region" {}
# variable "asg_name" {}
# variable "launch_template_name" {}
# variable "instance_type" {}
# variable "subnet_ids" {}

# provider "aws" { 
#   region = var.aws_region
# }

resource "aws_launch_template" "asg_launch_template" {
  name                        = "${var.henryproject}-instance"
  image_id                    = var.ami_id # "ami-12345678"  Replace with the desired AMI ID
  instance_type               = var.instance_type
  key_name                    = var.key_name
   network_interfaces {
    device_index    = 0
    associate_public_ip_address = true
    security_groups             = [ var.webserver-secgrp ]  # Replace with desired security group IDs
  }

 # associate_public_ip_address = true
        tags = {
            Name = "${var.henryproject}-ec2instance"
        }
  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  } 
}

resource "aws_autoscaling_group" "asg" {
  name                        = "${var.henryproject}-asg"
  min_size                    = 2
  max_size                    = 5
  desired_capacity            = 2
  vpc_zone_identifier         = [ var.publicsubnet2, var.publicsubnet ]
  
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = aws_launch_template.asg_launch_template.latest_version
  }
  health_check_grace_period   = 300
  health_check_type           = "ELB"

  target_group_arns = [ var.alb_target_group_arn ]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = filebase64("${path.module}./script.tpl")
}
