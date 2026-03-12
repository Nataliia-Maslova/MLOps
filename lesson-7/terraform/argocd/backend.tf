terraform {
  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }

  }

  required_version = ">= 1.5.0"
}