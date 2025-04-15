# modules/ipam/outputs.tf

output "ipam_id" {
  description = "ID of the created IPAM"
  value       = aws_vpc_ipam.main_ipam.id
}

output "private_scope_id" {
  description = "ID of the private IPAM scope"
  value       = aws_vpc_ipam_scope.private_scope.id
}

# Region 1 pool outputs
output "region1_pool_arn" {
  description = "ARN of the Region 1 top-level pool"
  value       = aws_vpc_ipam_pool.region1.arn
}

output "region1_prod_pool_arn" {
  description = "ARN of the Region 1 Production pool"
  value       = aws_vpc_ipam_pool.region1_prod.arn
}

output "region1_nonprod_pool_arn" {
  description = "ARN of the Region 1 Non-Production pool"
  value       = aws_vpc_ipam_pool.region1_nonprod.arn
}

output "region1_prod_subnet1_pool_arn" {
  description = "ARN of the Region 1 Production Subnet 1 pool"
  value       = aws_vpc_ipam_pool.region1_prod_subnet1.arn
}

output "region1_prod_subnet2_pool_arn" {
  description = "ARN of the Region 1 Production Subnet 2 pool"
  value       = aws_vpc_ipam_pool.region1_prod_subnet2.arn
}

output "region1_nonprod_subnet1_pool_arn" {
  description = "ARN of the Region 1 Non-Production Subnet 1 pool"
  value       = aws_vpc_ipam_pool.region1_nonprod_subnet1.arn
}

output "region1_nonprod_subnet2_pool_arn" {
  description = "ARN of the Region 1 Non-Production Subnet 2 pool"
  value       = aws_vpc_ipam_pool.region1_nonprod_subnet2.arn
}

# Region 2 pool outputs
output "region2_pool_arn" {
  description = "ARN of the Region 2 top-level pool"
  value       = aws_vpc_ipam_pool.region2.arn
}

output "region2_prod_pool_arn" {
  description = "ARN of the Region 2 Production pool"
  value       = aws_vpc_ipam_pool.region2_prod.arn
}

output "region2_nonprod_pool_arn" {
  description = "ARN of the Region 2 Non-Production pool"
  value       = aws_vpc_ipam_pool.region2_nonprod.arn
}

output "region2_prod_subnet1_pool_arn" {
  description = "ARN of the Region 2 Production Subnet 1 pool"
  value       = aws_vpc_ipam_pool.region2_prod_subnet1.arn
}

output "region2_prod_subnet2_pool_arn" {
  description = "ARN of the Region 2 Production Subnet 2 pool"
  value       = aws_vpc_ipam_pool.region2_prod_subnet2.arn
}

output "region2_nonprod_subnet1_pool_arn" {
  description = "ARN of the Region 2 Non-Production Subnet 1 pool"
  value       = aws_vpc_ipam_pool.region2_nonprod_subnet1.arn
}

output "region2_nonprod_subnet2_pool_arn" {
  description = "ARN of the Region 2 Non-Production Subnet 2 pool"
  value       = aws_vpc_ipam_pool.region2_nonprod_subnet2.arn
}
