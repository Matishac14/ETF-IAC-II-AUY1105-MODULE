data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "this" {
  # checkov:skip=CKV_AWS_135:Las instancias de la familia t2 (ej. t2.micro) no soportan ebs_optimized.
  # checkov:skip=CKV_AWS_126:Se omite monitorización detallada para evitar cargos en CloudWatch.
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  #Rol para SSM Sesión Manager
  iam_instance_profile = "LabInstanceProfile"

  #Cifrado de disco raíz
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  #Mitigación de SSRF (Server Side Request Forgery) IMDSv2 obligatorio
  metadata_options {
    http_tokens = "required"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.purpose}-EC2"
  })
}