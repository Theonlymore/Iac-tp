# Création du Dockerfile
resource "local_file" "dockerfile" {
  filename = "${path.module}/Dockerfile"
  content  = <<-EOF
    FROM debian:bullseye-slim

    RUN apt-get update && apt-get install -y apache2 && apt-get clean

    EXPOSE 80

    CMD ["apache2ctl", "-D", "FOREGROUND"]
  EOF
}

# Build et push de l'image vers DockerHub
resource "null_resource" "docker_build" {
  triggers = {
    dockerfile_content = local_file.dockerfile.content
  }

  provisioner "local-exec" {
    command = <<EOF
      docker login -u onlymore -p dckr_pat_yG8eEkSOFak_jGT7j_cvZYDvkGk
      docker build -t onlymore/esgi-frontend:latest .
      docker push onlymore/esgi-frontend:latest
    EOF
  }

  depends_on = [local_file.dockerfile]
}

# Output de l'URL de l'image
output "docker_image_url" {
  value = "onlymore/esgi-frontend:latest"
} 
