output "vpc_id" {
  description = "ID de la VPC creada por el módulo vpc."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs de subnets públicas creadas por el módulo vpc."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs de subnets privadas creadas por el módulo vpc."
  value       = aws_subnet.private[*].id
}