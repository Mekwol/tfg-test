# modules/ipam/variables.tf
variable "delegated_account_id" {
  description = "ID of the delegated AWS account"
  type        = string
}

variable "aws_regions" {
  description = "List of AWS regions to deploy IPAM to"
  type        = list(string)
}

variable "tfg_test_account1_id" {
  description = "ID of the test account to share IPAM with"
  type        = string
}


