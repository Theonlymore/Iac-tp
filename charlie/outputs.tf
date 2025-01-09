output "instance_public_ip" {
    value = aws_instance.web_a.public_ip
    description = "The public IP address of the web instance"
  }


output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_username" {
  value = aws_db_instance.main.username
}

output "rds_password" {
  value = aws_db_instance.main.password
  sensitive = true

}

output "rds_db_name" {
  value = aws_db_instance.main.db_name
}
