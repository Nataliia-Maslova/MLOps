ArgoCD Deployment on AWS EKS (GitOps)

This project demonstrates how to deploy ArgoCD on AWS EKS using Terraform and Helm and manage application deployment using the GitOps approach.

1. Infrastructure Deployment (Terraform)

To install ArgoCD in the Kubernetes cluster using the Helm chart, run the following commands.

# Go to the Terraform configuration directory
cd terraform/argocd

# Initialize Terraform providers
terraform init

# Deploy ArgoCD
terraform apply -auto-approve

Note:
The configuration uses the parameter wait = false.
On small EKS nodes (for example t3.micro or t3.small) pods may require additional time to become Ready due to AWS networking limits and pod density restrictions.

2. Verify ArgoCD Installation

After Terraform finishes, check the status of the pods in the infra-tools namespace:

kubectl get pods -n infra-tools

You should see pods with the prefix:

argocd-

Example components:

argocd-server

argocd-repo-server

argocd-application-controller

argocd-redis

argocd-dex-server

If some pods are in Pending state, inspect the reason:

kubectl describe pod <pod-name> -n infra-tools

A common issue on small AWS instances is:

Too many pods

or insufficient CPU / memory resources.

3. Access ArgoCD UI

To access the ArgoCD web interface, use port forwarding:

kubectl port-forward svc/argocd-server -n infra-tools 8080:443

Then open in your browser:

https://localhost:8080

Login credentials:

Username

admin

Password

Retrieve the initial password with:

kubectl -n infra-tools get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 --decode
4. Application Deployment (GitOps)

The deployment is automated using an ArgoCD Application manifest.

Register the application in the cluster:

kubectl apply -f manifests/application.yaml

Verify the application status:

kubectl get applications -n infra-tools

ArgoCD monitors the repository:

Nataliia-Maslova/MLOps

Branch:

lesson-7

Application manifests are stored in:

lesson-7/namespaces/application

Whenever changes are pushed to this directory, ArgoCD automatically synchronizes the cluster state with the repository.

5. Verify Application Deployment

Make sure the application (for example nginx) is running in the target namespace:

kubectl get pods -n application

You should see a running nginx pod.

Project Structure
terraform/
 └ argocd/
     ├ main.tf
     ├ providers.tf
     ├ variables.tf
     ├ backend.tf
     ├ outputs.tf
     └ values/
         └ argocd-values.yaml

manifests/
 └ application.yaml

namespaces/
 └ application/
     ├ deployment.yaml
     └ service.yaml

Directories description

terraform/argocd/ — Terraform configuration for installing ArgoCD via Helm

manifests/application.yaml — ArgoCD Application resource

namespaces/application/ — Kubernetes manifests for the deployed application

Cleanup (Important)

To avoid AWS charges, remove the infrastructure after finishing the task:

terraform destroy

Then verify that no EKS resources remain in the AWS console.
