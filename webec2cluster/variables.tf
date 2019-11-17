# Region shoul dnot be specified as any of the datatype
variable "region" {
  default = "us-east-1"
}
variable "profile" {
  type    = "string"
  default = "pythonAutomation"
}
variable "shared_credentials_file" {
  type    = "string"
  default = "/Users/navaneethreddy/.aws/credentials"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
variable "ssh_port" {
  description = "SSH port to login into server"
  type        = number
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
