terraform {
  required_providers {
    docker = {
      source = "calxus/docker"
      version = "3.0.0"
    }
  }
}

provider "docker" {
    host = "unix:///var/run/docker.sock"  # Utiliser Docker en mode local
}
