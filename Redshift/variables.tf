variable "aws_region" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "us-east-1"
}
variable "availability_zone" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "us-east-1a"
}
variable "public_ip" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "true"
}
variable "final_snapshot" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "true"
}
variable "vpc_cidr" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "10.0.0.0/16"
}
variable "redshift_subnet_cidr_1" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "10.0.1.0/24"
}
variable "redshift_subnet_cidr_2" {
  description = "The default region for launching redshift"
  type        = "string"
  default     = "10.0.2.0/24"
}
variable "iampolicy" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "MyCustomcloud-SPP-Role"
}
variable "iamrole" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "MyCustomcloud-SPR-Role"
}
variable "rs_cluster_identifier" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "redshiftcluster"
}
variable "rs_database_name" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "redshift_cluster"
}
variable "rs_master_username" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "navaneethreddydevops"
}
variable "rs_master_pass" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "Navaneethreddydevops1"
}
variable "rs_nodetype" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "dc2.large"
}
variable "rs_cluster_type" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "single-node"
}
variable "bucketname" {
  description = "The default availability zone for launching redshift"
  type        = "string"
  default     = "terraform-bucket-dev"
}