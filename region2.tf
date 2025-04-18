# --------------------------
# Create Top-Level IPAM Pool for Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2" {
  provider       = aws.delegated_account
  ipam_scope_id  = aws_vpc_ipam_scope.private_scope.id
  locale         = "us-east-2"
  address_family = "ipv4"
  description    = "Top-Level Region 2 /16 Pool"
}

resource "aws_vpc_ipam_pool_cidr" "region2_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region2.id
  cidr         = "10.1.0.0/16"
}

# --------------------------
# Create Pools for Production & Non-Production in Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2_prod" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
  cidr         = "10.1.0.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region2_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_cidr" {
  provider     = aws.delegated_account
  ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
  cidr         = "10.1.128.0/17"
  depends_on   = [aws_vpc_ipam_pool_cidr.region2_cidr]
}

# --------------------------
# Create Sub-Pools for Each Environment in Region 2
# --------------------------
resource "aws_vpc_ipam_pool" "region2_prod_subnet1" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_subnet1_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region2_prod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_prod_subnet2" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_prod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_prod_subnet2_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region2_prod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_prod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod_subnet1" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Subnet 1"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_subnet1_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region2_nonprod_subnet1.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_nonprod_cidr]
}

resource "aws_vpc_ipam_pool" "region2_nonprod_subnet2" {
  provider            = aws.delegated_account
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = "us-east-2"
  address_family      = "ipv4"
  description         = "Region 2 Non-Production Subnet 2"
  source_ipam_pool_id = aws_vpc_ipam_pool.region2_nonprod.id
}

resource "aws_vpc_ipam_pool_cidr" "region2_nonprod_subnet2_cidr" {
  provider       = aws.delegated_account
  ipam_pool_id   = aws_vpc_ipam_pool.region2_nonprod_subnet2.id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.region2_nonprod_cidr]
}
