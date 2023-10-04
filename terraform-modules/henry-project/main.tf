# Below is the provider which helps in connecting with AWS Account
provider "aws" {
  region = "us-east-1"
  profile = "terraformprofile"
}

# create vpc
module "vpc" {
    source = "../modules/dynamodb-henry"
    aws_region              = var.aws_region
    henryproject            = var.henryproject
    vpc_cidr                = var.vpc_cidr
    public_bastionsubnet1   = var.public_bastionsubnet1
    publicsubnet2           = var.publicsubnet2
    privatesubnet1          = var.privatesubnet1
    privatesubnet2          = var.privatesubnet2
}

# security
module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "application_load_balancer" {
  source = "../modules/alb"
  henryproject        = module.vpc.henryproject
  ec2_instances       = module.ec2.ec2_instances
  ec2_instances2      = module.ec2.ec2_instances2
  alb_sec_grp         = module.security.alb_sec_grp
  publicsubnet        = module.vpc.publicsubnet
  publicsubnet2       = module.vpc.publicsubnet2
  vpc_id              = module.vpc.vpc_id
}

#database
module "database" {
  source = "../modules/database"
  henryproject               = module.vpc.henryproject
  engine                     = var.engine
  engine_version             = var.engine_version
  identifier                 = var.identifier
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  storage                    = var.storage
  storage_type               = var.storage_type 
  privatesubnet1             = module.vpc.privatesubnet1
  privatesubnet2             = module.vpc.privatesubnet2
  rds_sg                     = module.security.rds_sg
}

 module "route_53" {
   source   =  "../modules/route_53"
   #domain_site = module.route_53.domain_site
   domain_name = var.domain_name
   sub_domain  = var.sub_domain
   application_loadbalancer = module.application_load_balancer.application_loadbalancer_dns_name
   application_load_balancer_zone_id = module.application_load_balancer.application_load_balancer_zone_id
 }

module "asg" {
  source = "../modules/asg"
  henryproject             = module.vpc.henryproject
  ami_id                   = var.ami_id
  ec2_instances            = module.ec2.ec2_instances
  key_name                 = var.key_name
  instance_type            = var.instance_type
  publicsubnet             = module.vpc.publicsubnet
  publicsubnet2            = module.vpc.publicsubnet2
  webserver-secgrp         = module.security.webserver-secgrp
  alb_target_group_arn     = module.application_load_balancer.alb_target_group_arn
}

module "ec2" {
  source                 = "../modules/ec2"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = module.vpc.publicsubnet
  webserver-secgrp       = module.security.webserver-secgrp
 
}