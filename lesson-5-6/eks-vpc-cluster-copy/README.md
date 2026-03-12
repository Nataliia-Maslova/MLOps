# Terraform AWS VPC + EKS Cluster

##  Опис проєкту

Цей проєкт демонструє створення повноцінної інфраструктури в AWS за допомогою **Terraform** з використанням **офіційних Terraform-модулів**:

- `terraform-aws-modules/vpc/aws` — для створення VPC
- `terraform-aws-modules/eks/aws` — для створення Kubernetes-кластера (EKS)

Інфраструктура побудована модульно та відповідає best practices:
- окремий модуль для VPC
- окремий модуль для EKS
- зберігання Terraform state у S3
- звʼязок між модулями через `terraform_remote_state`

---

##  Структура проєкту

```text
eks-vpc-cluster/
├── backend.tf
├── terraform.tf
├── variables.tf
├── outputs.tf
├── main.tf
│
├── vpc/
│   ├── backend.tf
│   ├── terraform.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── main.tf
│
├── eks/
│   ├── backend.tf
│   ├── terraform.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── main.tf
│
└── README.md


Передумови

Перед початком роботи необхідно:

AWS акаунт
Налаштований AWS CLI з профілем goit-terraform
Terraform версії >= 1.5.0
S3 bucket для збереження Terraform state
(у цьому проєкті використовується mlops-tfstate-goit-nataliia у регіоні eu-south-2)

Запуск проєкту

Перейдіть у кореневу директорію проєкту:
cd eks-vpc-cluster

Ініціалізуйте Terraform:
terraform init

Перевірте план змін (опціонально):
terraform plan

Створіть інфраструктуру:
terraform apply

Підтвердьте виконання, ввівши:
yes

Після цього Terraform автоматично створить:

VPC з публічними та приватними сабнетами
EKS-кластер
Дві managed node group-и

Підключення до Kubernetes (EKS)

Після успішного terraform apply необхідно оновити kubeconfig:
aws eks --region eu-south-2 update-kubeconfig --name goit-mlops --profile goit-terraform

Перевірте підключення до кластера та стан нод:
kubectl get nodes

Очікуваний результат — дві ноди у статусі Ready.

Видалення ресурсів (ВАЖЛИВО)

Ресурси AWS можуть створювати витрати.
Після перевірки проєкту обовʼязково видаліть інфраструктуру:

terraform destroy

Підтвердьте дію, ввівши yes.