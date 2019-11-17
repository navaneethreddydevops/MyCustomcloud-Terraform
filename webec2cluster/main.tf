provider "aws" {
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}
resource "aws_launch_configuration" "launchtemplate" {
  image_id        = var.image[var.region]
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.securitygroup.id]
  user_data       = <<-EOF
                #!/bin/bash
                echo "Hello World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_security_group" "securitygroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  ingress {
    # TLS (change to whatever ports you need)
    from_port = var.server_port
    to_port   = var.server_port
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["172.31.0.0/16"] # add a CIDR block here
  }
  ingress {
    # TLS (change to whatever ports you need)
    from_port = var.ssh_port
    to_port   = var.ssh_port
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["173.172.34.56/32"] # add a CIDR block here
  }

  egress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_vpc" "default" {
  default = true

}
data "aws_subnet_ids" "subnetids" {
  vpc_id = data.aws_vpc.default.id

}

resource "aws_autoscaling_group" "autoscaling" {
  launch_configuration = aws_launch_configuration.launchtemplate.name
  vpc_zone_identifier  = data.aws_subnet_ids.subnetids.ids
  min_size             = 2
  max_size             = 3
  tag {
    key                 = "Name"
    value               = "Terraform ASG"
    propagate_at_launch = true
  }
}
