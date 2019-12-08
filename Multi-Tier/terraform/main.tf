provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_vpc" "multitier_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name                = "Multitier-VPC"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "MultiTier"
  }
}
resource "aws_subnet" "PUBLIC_SUBNET_1" {
  vpc_id                  = "${aws_vpc.multitier_vpc.id}"
  cidr_block              = "${var.PUBLIC_SUBNET_CIDR_1}"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name                = "PUBLIC_SUBNET_1"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PublicSubnet1"
  }
}
resource "aws_subnet" "PUBLIC_SUBNET_2" {
  vpc_id                  = "${aws_vpc.multitier_vpc.id}"
  cidr_block              = "${var.PUBLIC_SUBNET_CIDR_2}"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = "true"
  tags = {
    Name                = "PUBLIC_SUBNET_2"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PublicSubnet2"
  }
}
resource "aws_subnet" "PRIVATE_SUBNET_1" {
  vpc_id            = "${aws_vpc.multitier_vpc.id}"
  cidr_block        = "${var.PRIVATE_SUBNET_CIDR_1}"
  availability_zone = "us-west-2a"
  tags = {
    Name                = "PRIVATE_SUBNET_1"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PrivateSubnet1"
  }
}
resource "aws_subnet" "PRIVATE_SUBNET_2" {
  vpc_id            = "${aws_vpc.multitier_vpc.id}"
  cidr_block        = "${var.PRIVATE_SUBNET_CIDR_2}"
  availability_zone = "us-west-2b"
  tags = {
    Name                = "PRIVATE_SUBNET_2"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PrivateSubnet2"
  }
}

#####Defining the Bastion Security Groups
resource "aws_security_group" "bastion_sg" {
  name        = "BASTION_SG"
  description = "Allows all Inbound Traffic"
  vpc_id      = "${aws_vpc.multitier_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.MY_HOME_CIDR}"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.PRIVATE_SUBNET_CIDR_1}"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.PRIVATE_SUBNET_CIDR_2}"]
  }
  tags = {
    Name                = "BASTION_SG"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "BASTION_SG"
  }
  depends_on = [
    "aws_vpc.multitier_vpc"
  ]
}

#####Defining the Application Loadbalancer Security Groups
resource "aws_security_group" "application_loadbalancer_sg" {
  name        = "application_loadbalancer_sg"
  description = "Allows all Inbound Traffic"
  vpc_id      = "${aws_vpc.multitier_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.PRIVATE_SUBNET_CIDR_1}"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.PRIVATE_SUBNET_CIDR_2}"]
  }
  tags = {
    Name                = "APPLICATION_LOAD_BALANCER"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "APPLICATION_LOAD_BALANCER"
  }
  depends_on = [
    "aws_vpc.multitier_vpc"
  ]
}
#####Defining the Application Security Groups
resource "aws_security_group" "application_sg" {
  name        = "application_sg"
  description = "Allows all Inbound Traffic"
  vpc_id      = "${aws_vpc.multitier_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.PUBLIC_SUBNET_CIDR_1}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.PUBLIC_SUBNET_CIDR_2}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.PUBLIC_SUBNET_CIDR_1}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.PUBLIC_SUBNET_CIDR_2}"]
  }
  tags = {
    Name                = "APPLICATION_SG"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "APPLICATION_LOAD_BALANCER"
  }
  depends_on = [
    "aws_vpc.multitier_vpc"
  ]
}
