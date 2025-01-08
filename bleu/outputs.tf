output "public_ip" {
  value       = aws_instance.web_instance.public_ip
  description = "The public IP of the web instance."
}

