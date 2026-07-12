# Ejemplo - Módulo S3

Provee un bucket Amazon S3 con hardening de seguridad completo habilitado por defecto:

- **Bloqueo total de acceso público** — las 4 opciones de `public_access_block` en `true`.
- **Versionado habilitado** — permite recuperar versiones anteriores de objetos.
- **Cifrado en reposo AES256** — SSE-S3 aplicado a todos los objetos.
- **Lifecycle policy (FinOps)** — elimina versiones no actuales y cargas incompletas a los 7 días.

## Requisitos

| Herramienta  | Versión       |
|--------------|---------------|
| Terraform    | >= 1.5.0      |
| AWS Provider | >= 5.0, < 7.0 |

## Variables de entrada

| Nombre         | Tipo          | Requerido | Default | Descripción |
|----------------|---------------|:---------:|---------|-------------|
| `project_name` | `string`      |    Yes    | —       | Prefijo para el nombre del bucket y tags. |
| `environment`  | `string`      |    Yes    | —       | Entorno: `dev`, `qa`, `prod`. |
| `bucket_name`  | `string`      |    Yes    | —       | Sufijo del bucket. Nombre final: `{project_name}-{environment}-{bucket_name}`. |
| `tags`         | `map(string)` |    No     | `{}`    | Etiquetas adicionales. |


## Outputs

| Nombre       | Descripción |
|--------------|-------------|
| `bucket_id`  | Nombre del bucket creado. |
| `bucket_arn` | ARN completo del bucket. |

## Ejemplo básico

```hcl
module "s3" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/s3?ref=v0.1.1"

  project_name = "etf-auy1105"
  environment  = "dev"
  bucket_name  = "artifacts"
}
# Bucket creado: etf-auy1105-dev-artifacts
```


## Recursos creados

| Recurso Terraform | Descripción |
|-------------------|-------------|
| `aws_s3_bucket` | Bucket principal. |
| `aws_s3_bucket_public_access_block` | Bloquea todo acceso público. |
| `aws_s3_bucket_versioning` | Habilita versionado. |
| `aws_s3_bucket_server_side_encryption_configuration` | Cifrado AES256 por defecto. |
| `aws_s3_bucket_lifecycle_configuration` | Limpia versiones y cargas antiguas a los 7 días. |

## Notas de seguridad (checks omitidos)

| Check           | Razón |
|-----------------|-------|
| `CKV_AWS_18`    | Access Logging omitido para evitar costos dobles de almacenamiento. |
| `CKV_AWS_144`   | Cross-Region Replication omitida para evitar costos de transferencia. |
| `CKV2_AWS_62`   | Sin enrutamiento EventBridge/SNS requerido en esta arquitectura. |
| `CKV_AWS_145`   | Se usa SSE-S3 (AES256) en lugar de KMS para mitigar costos. |
