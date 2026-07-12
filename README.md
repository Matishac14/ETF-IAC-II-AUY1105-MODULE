# ETF-IAC-II-AUY1105-MODULE

- Módulos Terraform reutilizables — Evaluación Final Transversal  
- Asignatura **AUY1105 — Infraestructura como Código II**


## Descripción

Repositorio de módulos Terraform **modulares, reutilizables y versionados** que
provisionan infraestructura en AWS siguiendo buenas prácticas de seguridad y FinOps.

## Módulos disponibles

| Módulo | Descripción | TF mínimo |
|--------|-------------|-----------|
| [`ec2`](./modules/ec2/README.md) | Instancia EC2 segura con SSM Session Manager | >= 1.5.0 |
| [`s3`](./modules/s3/README.md)   | Bucket S3 con hardening completo             | >= 1.5.0 |
| [`vpc`](./modules/vpc/README.md) | VPC con subnets públicas y privadas          | >= 1.5.0 |

## Requisitos globales

| Herramienta  | Versión requerida |
|--------------|-------------------|
| Terraform    | >= 1.5.0          |
| AWS Provider | >= 5.0, < 7.0     |

## Uso rápido

```hcl
module "vpc" {
  source      = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/vpc?ref=v0.1.1"
  project_name = "etf-auy1105"
  environment  = "dev"
}

module "ec2" {
  source             = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/ec2?ref=v0.1.1"
  project_name       = "etf-auy1105"
  environment        = "dev"
  purpose            = "web"
  subnet_id          = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.ssm_sg.id]
}

module "s3" {
  source       = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/s3?ref=v0.1.1"
  project_name = "etf-auy1105"
  environment  = "dev"
  bucket_name  = "artifacts"
}
```

#### Siempre apunta a un tag semántico (`?ref=v0.1.1`) en lugar de `ref=main` en entornos productivos.

## Versionado semántico

Este repositorio sigue SemVer Las versiones
se gestionan automáticamente con Release-Please
via Conventional Commits. Ver historial en CHANGELOG.md

## CI/CD

Cada PR ejecuta el workflow `ci.yml` que valida:
1. `terraform fmt -check`
2. `terraform validate`
3. `tflint`
4. `checkov`

# Mejoras implementadas de repo EV3

## Mejoras de seguridad (Zero Trust):

- Migración de SSH a SSM Session Manager para acceso remoto seguro a instancias EC2.
- Hardering de VPC, subnets y security groups para minimizar exposición a Internet.
- Bloqueo de acceso público a buckets S3

## Mejoras de Eficiencia:

- Política de ciclo de vida de objetos S3 para limpieza automática de archivos temporales.
- Cifrado nativo (AES256).
- Optimización de instancias EC2 para habilitar EBS Optimized y deshabilitar monitorización detallada.

## Gobernanza:

- Inmutabilidad de dependencias
- Separación de responsabilidades
- Políticas de naming y tagging consistentes

# Referencias buenas prácticas:

## Modulo vpc/main.tf

- Asignación de IPs Públicas (Zero Trust): CKV_AWS_130
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/ensure-vpc-subnets-do-not-assign-public-ip-by-default

- VPC Flow Logs (FinOps/Supresión): CKV2_AWS_11 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-logging-policies/logging-9-enable-vpc-flow-logging

- Security Group por defecto (Zero Trust): CKV2_AWS_12 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/networking-4

## Modules/ec2/main.tf

- Mitigación SSRF obligando IMDSv2 (Ciberseguridad): CKV_AWS_79
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-general-31

- Optimización EBS (FinOps/Supresión para t2.micro): CKV_AWS_135 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-that-ec2-is-ebs-optimized

- Monitorización Detallada (FinOps/Supresión CloudWatch): CKV_AWS_126 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-logging-policies/ensure-that-detailed-monitoring-is-enabled-for-ec2-instances

## Modules/s3/main.tf
- Access Logging (FinOps/Supresión): CKV_AWS_18 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/s3-policies/s3-13-enable-logging

- Replicación Cross-Region (FinOps/Supresión): CKV_AWS_144 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-that-s3-bucket-has-cross-region-replication-enabled

- Cifrado KMS vs AES256 Nativo (FinOps/Supresión): CKV_AWS_145 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/ensure-that-s3-buckets-are-encrypted-with-kms-by-default

- Notificaciones EventBridge/SNS (Arquitectura/Supresión): CKV2_AWS_62 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-logging-policies/bc-aws-2-62

- Ciclo de Vida de Objetos (FinOps): CKV2_AWS_61 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-logging-policies/bc-aws-2-61

- Limpieza de Subidas Incompletas (FinOps): CKV_AWS_300 
  - Referencia: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-general-policies/bc-aws-300