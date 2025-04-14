variable "aws_regions" {
  type    = list(string)
  default = ["us-east-1", "us-east-2"]
}

variable "aws_region" {
  description = "Primary AWS region"
  type        = string
}

variable "root_ou_id" {
  description = "AWS Organizations Root OU ID"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for security group access"
  type        = string
}

variable "linux_ip" {
  description = "Linux instance IP for security group access"
  type        = string
}

variable "tfg_test_account1_id" {
  description = "AWS Account ID for tfg-test-account1"
  type        = string
}

variable "delegated_account_id" {
  description = "AWS Account ID for delegated account where IPAM is created"
  type        = string
}
