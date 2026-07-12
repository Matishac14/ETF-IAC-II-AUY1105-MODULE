variable "project_name" {
  description = "Prefijo para los recursos y tags del proyecto."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, prod)."
  type        = string
}

variable "purpose" {
  description = "Propósito de la instancia EC2 (por ejemplo, 'web', 'app', 'db')."
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet donde se lanzará la instancia EC2. Debe ser una subnet pública si se requiere IP pública."
  type        = string
}

variable "security_group_ids" {
  description = "ID del security group a asociar a la instancia."
  type        = list(string)
}

variable "instance_type" {
  description = "Tipo de instancia EC2."
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large"], var.instance_type)
    error_message = "Solo se permiten tipos de instancia t2.nano, t2.micro, t2.small, t2.medium y t2.large."
  }
}
