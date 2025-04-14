# --------------------------
# Create a single AWS IPAM
# --------------------------
resource "aws_vpc_ipam" "main_ipam" {
  provider    = aws.delegated_account
  description = "Global IPAM for managing CIDR blocks"

 operating_regions {
    region_name = var.aws_regions[0]
  }

  operating_regions {
    region_name = var.aws_regions[1]
  }
}
# --------------------------
# Create Top-Level IPAM Scope
# --------------------------

resource "aws_vpc_ipam_scope" "private_scope" {
  provider    = aws.delegated_account
  ipam_id     = aws_vpc_ipam.main_ipam.id
  description = "Private IPAM Scope"
}
