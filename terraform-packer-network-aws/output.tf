
#############################################
# EIPs:
#############################################

output "eip_public_ip" {
  value = aws_eip.eip.*.public_ip
}

#############################################
# DNS EIPs:
#############################################

output "eip_public_dns" {
  value = aws_eip.eip.*.public_dns
}

#############################################
# VPC id:
#############################################

output "vpc_packer_id" {
  description = "The ID of the VPC Packer"
  value       = aws_vpc.packer_vpc.id
}

#############################################
# Subnet id:
#############################################

output "public_subnets_packer" {
  description = "List of IDs of public subnets Packer"
  value       = aws_subnet.public_subnet_packer.*.id
}

#############################################
# SG id:
#############################################

output "security_group_packer_id" {
  description = "The ID of the security group Packer"
  value       = aws_security_group.sgpacker.id
}