output "nginx_container_id" {
  description = "ID du conteneur Nginx"
  value       = docker_container.nginx.id
}

output "nginx_image_id" {
  description = "ID de l'image Nginx"
  value       = docker_container.nginx.image
}

output "nginx_container_name" {
  value = docker_container.nginx.name
  description = "Le nom du container NGINX"
}

