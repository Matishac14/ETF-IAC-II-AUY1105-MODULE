variable "project_name" {
  description = "Prefijo para los recursos y tags del proyecto."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de bloques CIDR para subnets públicas."
  type        = list(string)
  default     = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de bloques CIDR para subnets privadas."
  type        = list(string)
  default     = ["10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24"]
}

variable "tags" {
  description = "Tags adicionales para los recursos."
  type        = map(string)
  default     = {}
}