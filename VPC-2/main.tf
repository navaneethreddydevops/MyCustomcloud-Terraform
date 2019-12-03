provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
data "aws_availability_zones" "available" {

}
#Creating the New VPC with required CIDR
resource "aws_vpc" "mainvpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Main-VPC"
  }
}
#Creating Internetgateway to talk to internet
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  tags = {
    Name = "InternetGateway"
  }
}
# Public Route Tables
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internetgateway.id}"
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
#Private Route Tables
resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.mainvpc.default_route_table_id}"
  tags = {
    Name = "PrivateRouteTable"
  }
}
# Creating the Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = 2
  cidr_block              = "${var.public_cidrs[count.index]}"
  vpc_id                  = "${aws_vpc.mainvpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "public-subnet.${count.index + 1}"
  }
}
# Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  cidr_block        = "${var.private_cidrs[count.index]}"
  vpc_id            = "${aws_vpc.mainvpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "private-subnet.${count.index + 1}"
  }
}
# Route Table association
resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"
  depends_on     = ["aws_route_table.public_route", "aws_subnet.public_subnet"]
}
resource "aws_route_table_association" "private_subnet_association" {
  count          = 2
  route_table_id = "${aws_default_route_table.private_route.id}"
  subnet_id      = "${aws_subnet.private_subnet.*.id[count.index]}"
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.private_subnet"]
}
#Creating SG's
resource "aws_security_group" "security_group" {
  name   = "mainsg"
  vpc_id = "${aws_vpc.mainvpc.id}"
}
resource "aws_security_group_rule" "ssh-allow" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group.id}"
  cidr_blocks       = ["173.172.34.56/32"]
}
resource "aws_security_group_rule" "allow-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.security_group.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
