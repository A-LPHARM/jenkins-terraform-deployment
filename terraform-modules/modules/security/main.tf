# Create Security Group
resource "aws_security_group" "secgrp" {
  name = "default-"
  vpc_id      = var.vpc_id

# To Allow SSH Transport
  ingress {
    description   = "allow ssh access"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

# To Allow HTTP Transport
  ingress {
    description   = "allow http access"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


##################################################################
# Create security group for the application load balancer
# terraform aws create security group
  resource "aws_security_group" "alb_sec_grp" {
  name = "alb security group"
  description =  "Enable http/https access on port 80 and 443"
  vpc_id      = var.vpc_id

# To Create https access port and ip
  ingress {
    description    = "allow ssh access"
    from_port      = 80
    to_port        = 80
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"] 
  }

# create https access port and ip
ingress {
    description    = "allow https access"
    from_port      = 443
    to_port        = 443
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"] 
  }

  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }

  tags = {
    name           = "alb security group"
  }
} 



##################################################################
# Create security group for the bastion host 
# terraform aws create security group
  resource "aws_security_group" "ssh-secgrp" {
  name_prefix = "ssh access"
  description =  "Enable SSH on port 22"
  vpc_id      = var.vpc_id

# To Create bastion security group with access ip
  ingress {
    description    = "allow ssh access"
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"] # insert your local ip address in bastion host
  }

  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }
} 

####################################################################

resource "aws_security_group" "webserver-secgrp" {
  name = "webserver-security-group"
  description =  "Enable http and SSH on port 80 and port 22 via ssh grp"
  vpc_id      = var.vpc_id

#  To Allow HTTP Transport into the ssh-grp
  ingress {
    description       = "allow http access"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]  # security for ec2 instance without bastion host
  }

#  To Allow SSH Transport into the ssh-grp
  ingress {
    description       = "allow ssh access"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################################################################
###########################################################################

#  Create the security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "Database security group"
  description =  "enable MYSQL/AURORA access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description = "Mysql access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.webserver-secgrp.id] # Allow inbound traffic from bastion subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
