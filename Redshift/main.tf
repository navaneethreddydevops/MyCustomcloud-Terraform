provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = ""
  profile                 = "default"
}
resource "aws_vpc" "redshift_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "Redshift-VPC"
  }
}
resource "aws_internet_gateway" "redshift_vpc_igw" {
  vpc_id = "${aws_vpc.redshift_vpc.id}"
  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}
resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = "${aws_vpc.redshift_vpc.id}"

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["173.172.34.56/32"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["173.172.34.56/32"]
  }
  tags = {
    Name = "redshift-sg"
  }
  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}
resource "aws_subnet" "redshift-vpc-subnet1" {
  vpc_id                  = "${aws_vpc.redshift_vpc.id}"
  cidr_block              = "${var.redshift_subnet_cidr_1}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = "${var.public_ip}"
  tags = {
    Name = "Redshift-Subnet1"
  }
  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}
resource "aws_subnet" "redshift-vpc-subnet2" {
  vpc_id                  = "${aws_vpc.redshift_vpc.id}"
  cidr_block              = "${var.redshift_subnet_cidr_2}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = "${var.public_ip}"
  tags = {
    Name = "Redshift-Subnet2"
  }
  depends_on = [
    "aws_vpc.redshift_vpc"
  ]
}
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name = "redshift-subnet-group"
  subnet_ids = ["${aws_subnet.redshift-vpc-subnet1.id}",
  "${aws_subnet.redshift-vpc-subnet2.id}"]
  tags = {
    Name = "Redshift-Subnet-Group"
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucketname}"
  acl    = "private"
  region = "${var.aws_region}"
}
resource "aws_s3_bucket_policy" "bucketpolicy" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = <<EOF
 {
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "Allowing specific user to acces the Bucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
          "${aws_s3_bucket.bucket.arn}"
      ]
    }
  ]
 }
 EOF
}
resource "aws_iam_policy" "s3_access_policy" {
  name   = "${var.iampolicy}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "bucketlevelpermissions",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucketByTags",
                "s3:GetLifecycleConfiguration",
                "s3:GetBucketTagging",
                "s3:GetInventoryConfiguration",
                "s3:ListBucketVersions",
                "s3:GetBucketLogging",
                "s3:ListBucket",
                "s3:HeadBucket",
                "s3:GetBucketPolicyStatus",
                "s3:ListBucketMultipartUploads",
                "s3:GetBucketWebsite",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetBucketNotification",
                "s3:GetReplicationConfiguration",
                "s3:ListMultipartUploadParts",
                "s3:ListAllMyBuckets",
                "s3:GetBucketCORS",
                "s3:GetAnalyticsConfiguration",
                "s3:CreateJob",
                "s3:GetBucketLocation",
                "s3:GetObjectVersion"
            ],
            "Resource": 
            [ 
                "${aws_s3_bucket.bucket.arn}"
                
            ]
        },
        {
            "Sid": "Object Level Permissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectVersionTorrent",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersionForReplication"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ]
        }
    ]
}
EOF
  depends_on = [
    "aws_iam_role.redshift_role_s3"
  ]
}
resource "aws_iam_role" "redshift_role_s3" {
  name               = "${var.iamrole}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "Assume Role permissions for EC2"
    }
  ]
}
EOF
  tags = {
    Name = "Redshift-Role"
  }
}
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier        = "${var.rs_cluster_identifier}"
  database_name             = "${var.rs_database_name}"
  master_username           = "${var.rs_master_username}"
  master_password           = "${var.rs_master_pass}"
  node_type                 = "${var.rs_nodetype}"
  cluster_type              = "${var.rs_cluster_type}"
  cluster_subnet_group_name = "${aws_redshift_subnet_group.redshift_subnet_group.id}"
  skip_final_snapshot       = "${var.final_snapshot}"

  depends_on = [
    "aws_vpc.redshift_vpc",
    "aws_default_security_group.redshift_security_group",
    "aws_redshift_subnet_group.redshift_subnet_group",
    "aws_iam_role.redshift_role_s3"
  ]
}
