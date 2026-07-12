output "bucket_id" {
  description = "ID del bucket S3 creado por el módulo s3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN del bucket S3 creado por el módulo s3."
  value       = aws_s3_bucket.this.arn
}