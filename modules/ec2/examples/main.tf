terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# La VPC y el SG se crean antes para proveer subnet_id y security_group_ids al módulo ec2.
# En producción estos valores vendrían de outputs del módulo vpc.
module "vpc" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/vpc?ref=v0.1.1"

  project_name = "etf-auy1105"
  environment  = "dev"
}

resource "aws_security_group" "ssm_sg" {
  name        = "etf-auy1105-dev-ssm-sg"
  description = "Solo permite tráfico saliente para SSM Session Manager."
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Permitir todo el tráfico saliente para SSM y parches."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "etf-auy1105-dev-ssm-sg"
    Terraform = "true"
  }
}

module "ec2" {
  source = "git::https://github.com/Matishac14/ETF-IAC-II-AUY1105-MODULE.git//modules/ec2?ref=v0.1.1"

  project_name       = "etf-auy1105"
  environment        = "dev"
  purpose            = "web"
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [aws_security_group.ssm_sg.id]

  tags = {
    Owner     = "matias.fernandez"
    Terraform = "true"
  }
}

output "instance_id" {
  description = "ID de la instancia EC2 creada."
  value       = module.ec2.instance_id
}

output "instance_ip" {
  description = "IP pública de la instancia EC2."
  value       = module.ec2.instance_ip
}