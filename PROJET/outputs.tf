output "instance_id" {
  value = aws_instance.test_instance.id
  description = "ID de l'instance EC2"
}

output "public_ip" {
  value = aws_instance.test_instance.public_ip
  description = "Adresse IP publique de l'instance EC2"
}

output "public_dns" {
  value = aws_instance.test_instance.public_dns
  description = "Nom DNS public de l'instance EC2"
}
