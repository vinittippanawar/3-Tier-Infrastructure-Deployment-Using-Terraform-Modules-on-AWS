resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-mysql-db"
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]

  tags = {
    Name = "${var.project_name}-mysql-db"
  }
}