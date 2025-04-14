variable "aws_regions" {
  description = "List of AWS regions to deploy resources to"
  type        = list(string)
}

variable "tfg_test_account1_id" {
  description = "ID of the test account"
  type        = string
}
