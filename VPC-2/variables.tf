variable "aws_region" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "10.100.0.0/16"
}
variable "public_cidrs" {
  description = "The default region for launching redshift"
  type        = "list"
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
}
variable "private_cidrs" {
  description = "The default region for launching redshift"
  type        = "list"
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
}
