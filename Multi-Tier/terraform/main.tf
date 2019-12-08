provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_vpc" "multitier_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
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
  vpc_id                  = "${aws_vpc.multitier_vpc.id}"
  cidr_block              = "${var.PRIVATE_SUBNET_CIDR_1}"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name                = "PRIVATE_SUBNET_1"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PrivateSubnet1"
  }
}
resource "aws_subnet" "PRIVATE_SUBNET_2" {
  vpc_id                  = "${aws_vpc.multitier_vpc.id}"
  cidr_block              = "${var.PRIVATE_SUBNET_CIDR_2}"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = "true"
  tags = {
    Name                = "PRIVATE_SUBNET_2"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "PrivateSubnet2"
  }
}
