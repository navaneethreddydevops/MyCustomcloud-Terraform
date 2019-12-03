provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_vpc" "redshift_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "Redshift-VPC"
  }
}