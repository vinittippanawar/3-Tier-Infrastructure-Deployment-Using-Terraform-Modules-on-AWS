data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

# -----------------------------
# Security Groups
# -----------------------------

resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # later can restrict to your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Allow traffic from web tier"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "App access from Web"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description = "SSH from anywhere for demo"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL from App tier only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from App"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# -----------------------------
# App EC2
# -----------------------------
module "app_ec2" {
  source              = "./modules/ec2"
  ami_id              = data.aws_ami.ubuntu.id
  subnet_id           = module.vpc.private_subnet_1_id
  security_group_id   = aws_security_group.app_sg.id
  key_name            = var.key_name
  instance_name       = "${var.project_name}-app-server"
  associate_public_ip = false
  user_data           = file("${path.module}/userdata/app.sh")
}

# -----------------------------
# RDS
# -----------------------------
module "rds" {
  source        = "./modules/rds"
  project_name  = var.project_name
  db_subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
  db_sg_id      = aws_security_group.db_sg.id
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
}

# -----------------------------
# Web EC2
# -----------------------------
module "web_ec2" {
  source              = "./modules/ec2"
  ami_id              = data.aws_ami.ubuntu.id
  subnet_id           = module.vpc.public_subnet_1_id
  security_group_id   = aws_security_group.web_sg.id
  key_name            = var.key_name
  instance_name       = "${var.project_name}-web-server"
  associate_public_ip = true

  user_data = templatefile("${path.module}/userdata/web.sh", {
    app_private_ip = module.app_ec2.private_ip
  })
}