output "vpc_id" {
  value = aws_vpc.test.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "rds_security_group_id" {
  description = "Security group ID for the RDS"
  value       = aws_security_group.my_rds_sg.id 
}