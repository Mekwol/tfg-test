# modules/ipam/main.tf

# --------------------------
# Create a single AWS IPAM
# --------------------------
resource "aws_vpc_ipam" "main_ipam" {
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
  ipam_id     = aws_vpc_ipam.main_ipam.id
  description = "Private IPAM Scope"
}

# --------------------------
# Create Top-Level IPAM Pool for Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1" {
  ipam_scope_id  = aws_vpc_ipam_scope.private_scope.id
  locale         = var.aws_regions[0]
  address_family = "ipv4"
  description    = "Top-Level Region 1 /16 Pool"
}

resource "aws_vpc_ipam_pool_cidr" "region1_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region1.id
  cidr         = "10.0.0.0/16"
}

# --------------------------
# Create Pools for Production & Non-Production in Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1_prod" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
  cidr         = "10.0.0.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region1_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
  cidr         = "10.0.128.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region1_cidr]
}

# --------------------------
# Create Sub-Pools for Each Environment in Region 1
# --------------------------
resource "aws_vpc_ipam_pool" "region1_prod_subnet1" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_subnet1_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region1_prod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_prod_subnet2" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_prod_subnet2_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region1_prod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod_subnet1" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_subnet1_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region1_nonprod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_nonprod_cidr]
}

resource "aws_vpc_ipam_pool" "region1_nonprod_subnet2" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[0]
  address_family      = "ipv4"
  description         = "Region 1 Non-Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region1_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region1_nonprod_subnet2_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region1_nonprod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region1_nonprod_cidr]
}

# --------------------------
# Create Top-Level IPAM Pool for Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2" {
  ipam_scope_id  = aws_vpc_ipam_scope.private_scope.id
  locale         = var.aws_regions[1]
  address_family = "ipv4"
  description    = "Top-Level Region 2 /16 Pool"
}

resource "aws_vpc_ipam_pool_cidr" "region2_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region2.id
  cidr         = "10.1.0.0/16"
}

# --------------------------
# Create Pools for Production & Non-Production in Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2_prod" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
  cidr         = "10.1.0.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region2_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
  cidr         = "10.1.128.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region2_cidr]
}

# --------------------------
# Create Sub-Pools for Each Environment in Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2_prod_subnet1" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_subnet1_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region2_prod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_prod_subnet2" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_subnet2_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region2_prod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod_subnet1" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_subnet1_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region2_nonprod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_nonprod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod_subnet2" {
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = var.aws_regions[1]
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_subnet2_cidr" {
  ipam_pool_id   = aws_vpc_ipam_pool.region2_nonprod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_nonprod_cidr]
}
