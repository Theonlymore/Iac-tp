variable "aws_region" {
  default = "us-east-1"
  description = "Région AWS pour déployer l'infrastructure"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"      # Exemple : Amazon Linux 2
  description = "AMI ID pour l'instance EC2"
}

variable "instance_type" {
  default = "t2.micro"                   # Type d'instance (ex : t2.micro pour Free Tier)
  description = "Type d'instance EC2"
}
