variable "aws_regions" {
  description = "List of AWS regions to deploy resources to"
  type        = list(string)
}

variable "tfg_test_account1_id" {
  description = "ID of the test account"
  type        = string
}

variable "linux_ip" {
  description = "The ip of my bastion host- linux insance"
  type        = string
}

variable "my_ip" {
  description = "my_ip"
  type        = string
i
}

variable "vpc_id_region1" {
  description = "Region1 vpc id"
  type        = string
}


