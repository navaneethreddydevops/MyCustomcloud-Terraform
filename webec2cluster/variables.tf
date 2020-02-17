# Region shoul dnot be specified as any of the datatype
variable "region" {
  default = "us-east-1"
}
variable "profile" {
  type    = "string"
  default = "default"
}
variable "shared_credentials_file" {
  type    = "string"
  default = "/Users/navaneethreddy/.aws/credentials"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = "string"
  default     = 80
}
variable "ssh_port" {
  description = "SSH port to login into server"
  type        = "string"
  default     = "22"
}
variable "image" {
  type = "map"
  default = {
    "us-east-1" = "ami-00dc79254d0461090"
    "us-west-2" = "image-4567"
  }
}
variable "instance_type" {
  description = "Type of instance for EC2"
  type        = "string"
  default     = "r4.xlarge"
}
variable "key_name" {
  type    = "string"
  default = "keypair"
}
variable "min_size" {
  type    = "string"
  default = "2"
}
variable "max_size" {
  type    = "string"
  default = "3"
}

