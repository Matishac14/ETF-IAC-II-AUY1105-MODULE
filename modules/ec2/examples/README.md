# Ejemplo - Módulo EC2

Provee una instancia **Amazon EC2** con Amazon Linux 2023 y las siguientes
medidas de seguridad habilitadas por defecto:

- **IMDSv2 obligatorio** — previene SSRF en el metadata service.
- **Disco raíz cifrado (gp3, 20 GB)** — EBS con cifrado en reposo.
- **Sin SSH expuesto** — acceso vía **AWS SSM Session Manager** únicamente.
- **AMI dinámica** — siempre usa la última versión de `al2023-ami-2023.*-x86_64`.

## Requisitos

| Herramienta  | Versión       |
|--------------|---------------|
| Terraform    | >= 1.5.0      |
| AWS Provider | >= 5.0, < 7.0 |

## Variables de entrada

| Nombre              | Tipo           | Requerido | Default      | Descripción |
|---------------------|----------------|:---------:|--------------|-------------|
| `project_name`      | `string`       | Yes        | —            | Prefijo para nombres de recursos y tags. |
| `environment`       | `string`       | Yes        | —            | Entorno: `dev`, `qa`, `prod`. |
| `purpose`           | `string`       | Yes        | —            | Rol funcional: `web`, `app`, `db`, etc. |
| `subnet_id`         | `string`       | Yes        | —            | ID de la subnet donde se lanzará la instancia. |
| `security_group_ids`| `list(string)` | Yes        | —            | IDs de Security Groups a asociar. |
| `instance_type`     | `string`       | No        | `"t2.micro"` | Tipo EC2. Solo familia `t2.*` permitida. |
| `tags`              | `map(string)`  | No        | `{}`         | Etiquetas adicionales. |


**Validación:** `instance_type` fuera de `t2.nano/micro/small/medium/large` genera error en `plan`.

## Outputs

| Nombre        | Descripción |
|---------------|-------------|
| `instance_id` | ID de la instancia EC2 creada. |
| `instance_ip` | IP pública de la instancia EC2. |

## Ejemplo básico

```hcl
module "ec2" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/ec2?ref=v0.1.1"

  project_name       = "etf-auy1105"
  environment        = "dev"
  purpose            = "web"
  subnet_id          = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.ssm_sg.id]
}
```

## Ejemplo con tags personalizados

```hcl
module "ec2" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/ec2?ref=v0.1.1"

  project_name       = "etf-auy1105"
  environment        = "prod"
  purpose            = "app"
  instance_type      = "t2.small"
  subnet_id          = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.ssm_sg.id]

  tags = {
    Owner      = "matias.fernandez"
    CostCenter = "IAC-II"
    Terraform  = "true"
  }
}
# Nombre generado: etf-auy1105-prod-app
```
## Notas de seguridad (checks omitidos)

| Check          | Razón |
|----------------|-------|
| `CKV_AWS_135`  | Las instancias `t2.*` no soportan EBS Optimized por limitación de AWS. |
| `CKV_AWS_126`  | Monitorización detallada omitida para evitar cargos en CloudWatch. |

## Dependencias

- El perfil IAM `LabInstanceProfile` debe existir en la cuenta (preconfigurado en AWS Academy).
- El Security Group debe permitir egress en puerto `443` para que SSM funcione.
