variable "aws_region" {
  description = "Регіон AWS для розгортання" 
}

variable "project_name" {
  description = "Назва проекту, що використовується для іменування кластера" 
}

variable "cluster_version" {
  default     = "1.31"
  description = "Версія Kubernetes" 
}

# Додаємо змінні для зв'язку з VPC
variable "vpc_id" {
  type        = string
  description = "ID існуючої VPC, яку ми отримаємо від модуля VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Список приватних підмереж для вузлів кластера"
}