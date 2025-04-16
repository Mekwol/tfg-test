variable "aws_regions" {
  type    = list(string)
  default = ["us-east-1", "us-east-2"]
}

# set in tfvars
variable "aws_region" {}

# set in tfvars
variable "root_ou_id" {}


# set in tfvars
#variable "mgmt_acct" {}

#myip
#variable "my_ip" {}

variable "linux_ip" {}

#variable "org_id" {
# description = "AWS Organization ID"
#type        = string
#}


variable "tfg_test_account1_id" {
  description = "AWS Account ID for tfg-test-account1"
  type        = string
}

variable "delegated_account_id" {
  description = "AWS Account ID for delegated account where IPAM is created"
  type        = string
}

variable "shared_core_network_id" {
  description = "ID of the shared Cloud WAN Core Network from the delegated account"
  type        = string
}
