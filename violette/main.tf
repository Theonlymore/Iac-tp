
resource "docker_network" "nginx_network" {
  name = "nginx_network"
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = "nginx:latest"  # Utiliser l'image officielle de NGINX
  ports {
    internal = 80
    external = 8080  # Port externe sur ta machine locale
  }

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  restart = "unless-stopped"
}

