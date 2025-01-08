output "public_ip" {
  value       = aws_eip.web_eip.public_ip
  description = "The public Elastic IP of the web instance."
}
