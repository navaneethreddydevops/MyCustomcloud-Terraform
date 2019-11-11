provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_launch_configuration" "launchtemplate" {
  imageid            = "ami-00dc79254d0461090"
  instance_type      = "r4.xlarge"
  aws_security_group = [aws_security_group.securitygroup.id]
  user_data          = <<-EOF
                #!/bin/bash
                echo "Hello World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

}
resource "aws_security_group" "securitygroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  ingress {
    # TLS (change to whatever ports you need)
    from_port = 443
    to_port   = 443
    protocol  = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["172.31.0.0/16"] # add a CIDR block here
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_autoscaling_group" "autoscaling" {
  launch_configuration = aws_launch_configuration.launchtemplate.name
  min_size             = 2
  max_size             = 3
  tag {
    key                 = "Name"
    value               = "Terraform ASG"
    propagate_at_launch = true
  }
}
