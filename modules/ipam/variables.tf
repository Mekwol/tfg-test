# modules/ipam/variables.tf

variable "aws_regions" {
  type        = list(string)
  description = "List of AWS regions to operate in"
  default     = ["us-east-1", "us-east-2"]
}
