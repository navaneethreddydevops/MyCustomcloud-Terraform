provider "aws" {
    "region" = "us-east-1"
}
resource "aws_instance" "ec2" {
    instance_type     = "t2.micro"
    availability_zone = "us-east-1a"
    ami               = "ami-00dc79254d0461090"
    user_data         = <<-EOF
                #!/bin/bash
                sudo service apache2 start
                EOF 
}