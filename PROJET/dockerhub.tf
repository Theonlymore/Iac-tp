# Build et push de l'image backend vers DockerHub
resource "null_resource" "backend_docker_build" {
  provisioner "local-exec" {
    command = <<EOF
      cd apps/backend
      docker login -u onlymore -p dckr_pat_yG8eEkSOFak_jGT7j_cvZYDvkGk
      docker build -t onlymore/esgi-backend:latest .
      docker push onlymore/esgi-backend:latest
    EOF
  }
}

# Build et push de l'image frontend vers DockerHub
resource "null_resource" "frontend_docker_build" {
  provisioner "local-exec" {
    command = <<EOF
      cd apps/frontend
      ls
      docker login -u onlymore -p dckr_pat_yG8eEkSOFak_jGT7j_cvZYDvkGk
      docker build -t onlymore/esgi-frontend:latest .
      docker push onlymore/esgi-frontend:latest
    EOF
  }
}

# Output de l'URL de l'image backend
output "backend_docker_image_url" {
  value = "onlymore/esgi-backend:latest"
}

# Output de l'URL de l'image frontend
output "frontend_docker_image_url" {
  value = "onlymore/esgi-frontend:latest"
}
