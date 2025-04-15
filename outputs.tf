# Output for easy reference
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.private.private_ip
}

# Add this to variables.tf
variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}



# Cloud WAN Outputs
#output "global_network_id" {
 # description = "ID of the AWS Cloud WAN Global Network"
  #value       = aws_networkmanager_global_network.global_network.id
#}

#output "core_network_id" {
 # description = "ID of the AWS Cloud WAN Core Network"
  #value       = aws_networkmanager_core_network.core_network.id
#}

#output "region1_vpc_attachment_id" {
 # description = "ID of the VPC attachment for Region 1"
  #value       = aws_networkmanager_vpc_attachment.region1_prod_attachment.id
#}

#output "region2_vpc_attachment_id" {
 # description = "ID of the VPC attachment for Region 2"
  #value       = aws_networkmanager_vpc_attachment.region2_prod_attachment.id
#}
