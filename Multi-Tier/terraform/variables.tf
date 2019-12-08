variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}
variable "vpc_cidr" {
  description = "The AWS region to create things in."
  default     = "10.102.0.0/16"
}
variable "PUBLIC_SUBNET_CIDR_1" {
  description = "Ingress Subnet AZ 1 CIDR"
  default     = "10.102.1.0/24"
}
variable "PUBLIC_SUBNET_CIDR_2" {
  description = "Ingress Subnet AZ 1 CIDR"
  default     = "10.102.2.0/24"
}
variable "PRIVATE_SUBNET_CIDR_1" {
  description = "Ingress Subnet AZ 1 CIDR"
  default     = "10.102.3.0/24"
}
variable "PRIVATE_SUBNET_CIDR_2" {
  description = "Ingress Subnet AZ 1 CIDR"
  default     = "10.102.4.0/24"
}
