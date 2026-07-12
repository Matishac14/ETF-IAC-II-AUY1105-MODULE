# Ejemplo - Módulo VPC

Provee una **red VPC completa en AWS** con subnets públicas y privadas
distribuidas automáticamente entre Availability Zones disponibles.

Recursos creados:
- **VPC** con DNS support y DNS hostnames habilitados.
- **Internet Gateway** para tráfico saliente de subnets públicas.
- **Subnets públicas** con `map_public_ip_on_launch = true`, distribuidas entre AZs.
- **Subnets privadas** distribuidas entre AZs.
- **Route Table pública** con ruta `0.0.0.0/0` → Internet Gateway.
- **Default Security Group** limpio asociado a la VPC.

## Requisitos

| Herramienta  | Versión       |
|--------------|---------------|
| Terraform    | >= 1.5.0      |
| AWS Provider | >= 5.0, < 7.0 |

## Variables de entrada

| Nombre                | Tipo           | Requerido | Default | Descripción |
|-----------------------|----------------|:---------:|---------|-------------|
| `project_name`        | `string`       | Yes        | —       | Prefijo para nombres de recursos y tags. |
| `environment`         | `string`       | Yes        | —       | Entorno: `dev`, `qa`, `prod`. |
| `vpc_cidr`            | `string`       | No        | `"10.1.0.0/16"` | Bloque CIDR de la VPC. |
| `public_subnet_cidrs` | `list(string)` | No        | `["10.1.10.0/24","10.1.11.0/24","10.1.12.0/24"]` | CIDRs de subnets públicas. |
| `private_subnet_cidrs`| `list(string)` | No        | `["10.1.20.0/24","10.1.21.0/24","10.1.22.0/24"]` | CIDRs de subnets privadas. |
| `tags`                | `map(string)`  | No        | `{}`    | Etiquetas adicionales. |


## Outputs

| Nombre               | Descripción |
|----------------------|-------------|
| `vpc_id`             | ID de la VPC creada. |
| `public_subnet_ids`  | Lista de IDs de subnets públicas. |
| `private_subnet_ids` | Lista de IDs de subnets privadas. |

## Ejemplo básico (defaults)

```hcl
module "vpc" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/vpc?ref=v0.1.1"

  project_name = "etf-auy1105"
  environment  = "dev"
}
# Crea VPC 10.1.0.0/16 + 3 subnets públicas + 3 privadas
```

## Ejemplo con CIDRs personalizados

```hcl
module "vpc" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/vpc?ref=v0.1.1"

  project_name         = "etf-auy1105"
  environment          = "prod"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

  tags = {
    Owner      = "matias.fernandez"
    CostCenter = "IAC-II"
    Terraform  = "true"
  }
}
```

## Ejemplo usando outputs en otros recursos

```hcl
# Security Group dentro de la VPC
resource "aws_security_group" "ssm_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "etf-auy1105-dev-ssm-sg"
  description = "Solo tráfico saliente para SSM"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Pasar subnet pública al módulo ec2
module "ec2" {
  source             = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/ec2?ref=v0.1.1"
  project_name       = "etf-auy1105"
  environment        = "dev"
  purpose            = "web"
  subnet_id          = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.ssm_sg.id]
}

output "private_subnets" { value = module.vpc.private_subnet_ids }
```

## Nombres generados

| Recurso            | Patrón |
|--------------------|--------|
| VPC                | `{project_name}-{environment}-vpc` |
| Internet Gateway   | `{project_name}-{environment}-igw` |
| Subnet pública N   | `{project_name}-{environment}-public-subnet-{N}` |
| Subnet privada N   | `{project_name}-{environment}-private-subnet-{N}` |
| Route Table pública| `{project_name}-{environment}-public-rt` |

## Notas de seguridad (checks omitidos)

| Check          | Razón |
|----------------|-------|
| `CKV2_AWS_11`  | VPC Flow Logs omitido para evitar costos en AWS Academy Learner Labs. |
| `CKV_AWS_130`  | Subnets públicas requieren `map_public_ip_on_launch = true` por diseño. |
