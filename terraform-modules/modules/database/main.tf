# Create the MySQL RDS database instance
resource "aws_db_instance" "mysql_instance" {
  engine                  = var.engine 
  engine_version          = var.engine_version  
  instance_class          = "db.t2.micro"
  allocated_storage       = var.storage
  storage_type            = var.storage_type
  availability_zone       = "us-east-1a"
  identifier              = var.identifier
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = 3306
  multi_az                = false
  publicly_accessible     = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.subnetdb.id
  vpc_security_group_ids  = [ var.rds_sg ]

  tags = {
    Name = "myrds"
  }
}

resource "aws_db_subnet_group" "subnetdb" {
  name       = "subnetdb"
  subnet_ids = [var.privatesubnet1 , var.privatesubnet2]

   tags = {
     Name = "${var.henryproject}-Dbsubnet"
  }
}