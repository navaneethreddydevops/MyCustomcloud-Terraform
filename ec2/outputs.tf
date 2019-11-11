output "public_ip" {
  value = "aws_instance.ec2.public_ip"
  description ="This will printout the public ip of ec2"
}
