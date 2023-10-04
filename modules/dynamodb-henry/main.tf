# Create VPC
resource "aws_vpc" "henryvpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    name = "${var.henryproject}-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = var.public_bastionsubnet1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.henryproject}-subnet"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = var.publicsubnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.henryproject}-subnet2"
  }
}

resource "aws_subnet" "privatesubnet1" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = var.privatesubnet1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.henryproject}-database-tier1"
  }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id     = aws_vpc.henryvpc.id
  cidr_block = var.privatesubnet2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.henryproject}-database-tier2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "publicig" {
  vpc_id = aws_vpc.henryvpc.id

  tags = {
    Name = "${var.henryproject}-igw"
  }
}

# Create Route Table
resource "aws_route_table" "routeigw" {
  vpc_id = aws_vpc.henryvpc.id 

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.publicig.id
  }

  tags = {
    Name = "${var.henryproject}-routetable"
  }
}

# Associate public Subnet with Route Table in az1
resource "aws_route_table_association" "publicsubnet_asst" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.routeigw.id
}

# Associate public Subnet with Route Table in az2
resource "aws_route_table_association" "publicsubnet2_asst" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.routeigw.id
}
