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

#########Launch Config For Bastion

resource "aws_launch_configuration" "Bastion_Launch_Config" {
  name_prefix     = "Bastion_Launch_Config-"
  image_id        = "ami-01e24be29428c15b2"
  instance_type   = "t2.micro"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.bastion_sg.id}"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    "aws_security_group.bastion_sg"
  ]
}
#########Launch Config For Bastion

resource "aws_autoscaling_group" "autoscaling_bastion" {
  name                 = "autoscaling_bastion"
  launch_configuration = "${aws_launch_configuration.Bastion_Launch_Config.name}"
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.PUBLIC_SUBNET_1.id}"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    "aws_launch_configuration.Bastion_Launch_Config",
    "aws_subnet.PUBLIC_SUBNET_1",
  ]
}

############Target Group with PORT 80
resource "aws_alb_target_group" "alb_target_group" {
  name     = "alb_target_group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.multitier_vpc.id}"

  depends_on = [
    "aws_vpc.multitier_vpc"
  ]
}

############Application Load Balancer
resource "aws_alb" "application_load_balancer" {
  name               = "application_load_balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.application_loadbalancer_sg}"]
  subnets            = ["${aws_subnet.PUBLIC_SUBNET_2.id}", "${aws_subnet.PUBLIC_SUBNET_1.id}"]

  enable_deletion_protection = false

  tags = {
    Name                = "application_load_balancer"
    Ownercontact        = "navaneethreddydevops@gmail.com"
    BusinessApplication = "application_load_balancer"
  }

  depends_on = [
    "aws_security_group.application_loadbalancer_sg",
    "aws_subnet.PUBLIC_SUBNET_1",
    "aws_subnet.PUBLIC_SUBNET_2"
  ]
}

############# Application Loadbalancer Listener

resource "aws_alb_listener" "application_loadbalancer_listner" {
  load_balancer_arn = "${aws_alb.application_load_balancer.id}"
  port              = "80"
  protocol          = "HTTP"
}

default_action {
  target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
  type             = "forward"
}

depends_on = [
  "aws_alb.application_load_balancer",
  "aws_alb_target_group.alb_target_group"
]

############Internet GateWay

resource "aws_internet_gateway" "INTERNET-GATEWAY" {
  vpc_id = "${aws_vpc.multitier_vpc.id}"

  depends_on = [
    "aws_vpc.multitier_vpc"
  ]

}

######### Route Table and Its Association

