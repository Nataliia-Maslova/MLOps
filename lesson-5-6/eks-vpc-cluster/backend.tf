terraform {
  backend "s3" {
    bucket  = "mlops-tfstate-goit-nataliia"
    key     = "root/terraform.tfstate"
    region  = "eu-south-2"
    encrypt = true
    profile = "goit-terraform"
  }
}