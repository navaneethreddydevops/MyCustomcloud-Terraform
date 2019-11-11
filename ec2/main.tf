provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_instance" "ec2" {
    instance_type          = "t2.micro"
    availability_zone      = "us-east-1a"
    ami                    = "ami-00dc79254d0461090"
    vpc_security_group_ids = [aws_security_group.allow_web_traffic.id]
    tags = {
      Name = "mycustomcloud-ec2"

    }
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF 
  }
resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  ingress {
    # TLS (change to whatever ports you need)
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }
  egress {
    # TLS (change to whatever ports you need)
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }
  ingress {
    from_port = 8090
    to_port   = 8090
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]

  }
  
}
