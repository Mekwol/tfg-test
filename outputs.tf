# Output for easy reference
output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "private_instance_private_ip" {
  description = "Private IP address of the private instance"
  value       = aws_instance.private.private_ip
}

output "region1_vpc_id" {
  description = "ID of the VPC in region 1"
  value       = aws_vpc.region1_vpc.id
}

output "region2_vpc_id" {
  description = "ID of the VPC in region 2"
  value       = aws_vpc.region2_vpc.id
}
