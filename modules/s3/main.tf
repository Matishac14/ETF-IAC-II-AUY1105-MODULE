# Creación del bucket S3 con nombre único global.
resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.environment}-${var.bucket_name}"

  # checkov:skip=CKV_AWS_18: Se omite Access Logging para evitar costos de almacenamiento doble.
  # checkov:skip=CKV_AWS_144: Se omite Cross-Region Replication para evitar costos de transferencia de datos.
  # checkov:skip=CKV2_AWS_62: No se requiere enrutamiento de notificaciones (EventBridge/SNS) en esta arquitectura.
  # checkov:skip=CKV_AWS_145: Se utiliza cifrado nativo SSE-S3 (AES256) en lugar de KMS gestionado para mitigar costos.

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-${var.bucket_name}-bucket"
    Environment = var.environment
  })
}

# Bloqueo de acceso público al bucket S3.
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Control de versiones.
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cifrado en reposo por default.
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Política de Ciclo de Vida (FinOps - Checkov CKV2_AWS_61 y CKV_AWS_300)
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "auto-delete-old-versions-and-failed-uploads"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }

    # CKV_AWS_300: Limpieza de subidas multiparte fallidas para evitar costos ocultos
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}