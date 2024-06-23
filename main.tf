provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "umami-postgres-security-group" {
  name_prefix = "umami-postgres-"
  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.cidr-blocks]
  }
}

resource "aws_db_instance" "umami-postgres-db-instance" {
  db_name                = "postgres"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  identifier             = "umami-postgres-db"
  username               = var.db-username
  password               = var.db-password
  vpc_security_group_ids = [aws_security_group.umami-postgres-security-group.id]
  skip_final_snapshot    = true
  storage_encrypted      = true
  publicly_accessible    = true
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.umami-postgres-db-instance.endpoint
}
