# Instance RDS MySQL
resource "aws_db_instance" "mysql" {
  identifier           = "mysql-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  storage_type        = "gp2"
  port                = 3306
  
  db_name             = "wordpress"
  username            = "dbadmin"
  password            = "votre_mot_de_passe_complexe"  # À remplacer par une variable ou un secret

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.mysql.id]
  
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true  # En production, mettre à false
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  tags = {
    Name = "mysql-db"
  }
}

# Variables de sortie pour la connexion
output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_name" {
  value = aws_db_instance.mysql.db_name
} 