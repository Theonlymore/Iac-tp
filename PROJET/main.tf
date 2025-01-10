provider "aws" {
  region = var.aws_region  # Utilise une variable pour la région AWS
}

resource "aws_instance" "test_instance" {
  ami           = var.ami_id             # Image AMI pour l’instance
  instance_type = var.instance_type      # Type d'instance

  tags = {
    Name = "TestInstance"                # Nom de l'instance
  }
}


git add .
git commit -m "Ajout du workflow Terraform"
git push origin main
