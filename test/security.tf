resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = {
    Name = "web-sg"
  }
}

# Security Group pour les tâches ECS
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Groupe de sécurité pour RDS
resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]  # Permet l'accès depuis les tâches ECS
  }

  tags = {
    Name = "postgres-sg"
  }
}

# Mise à jour du groupe de sécurité des tâches ECS
resource "aws_security_group_rule" "ecs_egress_postgres" {
  type                     = "egress"
  from_port               = 5432
  to_port                 = 5432
  protocol                = "tcp"
  source_security_group_id = aws_security_group.postgres.id
  security_group_id       = aws_security_group.ecs_tasks.id
}

# Mise à jour du groupe de sécurité pour MySQL
resource "aws_security_group" "mysql" {
  name        = "mysql-sg"
  description = "Security group for MySQL RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  tags = {
    Name = "mysql-sg"
  }
}

# Mise à jour de la règle pour ECS
resource "aws_security_group_rule" "ecs_egress_mysql" {
  type                     = "egress"
  from_port               = 3306
  to_port                 = 3306
  protocol                = "tcp"
  source_security_group_id = aws_security_group.mysql.id
  security_group_id       = aws_security_group.ecs_tasks.id
}