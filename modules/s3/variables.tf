variable "project_name" {
  description = "Prefijo para los recursos y tags del proyecto."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, prod)."
  type        = string
}

variable "bucket_name" {
  description = "Nombre único global del bucket S3."
  type        = string
}

variable "tags" {
  description = "Tags adicionales para los recursos."
  type        = map(string)
  default     = {}
}