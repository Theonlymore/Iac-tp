# Security Group pour l'Application Load Balancer (ALB)
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  # Permet l'accès HTTP depuis Internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permet l'accès SSH pour administration
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permet tout trafic sortant
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

# Security Group pour les tâches ECS (Frontend et Backend)
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  vpc_id      = aws_vpc.main.id

  # Permet la communication interne Frontend → Backend (port 3001)
  ingress {
    from_port       = 3001
    to_port         = 3001
    protocol        = "tcp"
    self            = true  # Autorise la communication entre conteneurs du même security group
  }

  # Permet l'accès depuis l'ALB (port 80)
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Permet tout trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group pour MySQL
resource "aws_security_group" "mysql" {
  name        = "mysql-sg"
  vpc_id      = aws_vpc.main.id

  # Permet l'accès MySQL depuis les tâches ECS (Backend)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  # Permet tout trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}