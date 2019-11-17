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
                sudo yum install -y git
                sudo yum install -y ansible
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
  target_group_arns    = [aws_lb_target_group.loadbalancertargetgroup.arn]
  health_check_type    = "ELB"
  min_size             = var.min_size
  max_size             = var.max_size
  tag {
    key                 = "Name"
    value               = "Terraform ASG"
    propagate_at_launch = true
  }
}
resource "aws_lb" "loadbalancer" {
  name               = "ec2-loadbalancer"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.subnetids.ids
  security_groups    = [aws_security_group.alb.id]

}
resource "aws_lb_target_group" "loadbalancertargetgroup" {
  name     = "loadbalancertg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "loadbalancer_http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.loadbalancer_http.arn
  priority     = 100
  condition {
    field  = "path-pattern"
    values = ["*"]
  }
  action {
    type              = "forward"
    target_group_arn = "aws_lb_target_group.loadbalancertargetgroup.arn"
  }
}
resource "aws_security_group" "alb" {
  name = "loadbalancer-securitygroup"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

