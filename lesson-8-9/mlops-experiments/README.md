MLOps Experiments with MLflow, ArgoCD and Prometheus

This project demonstrates a simple MLOps experiment tracking workflow deployed in Kubernetes using ArgoCD.

The infrastructure includes:

MLflow Tracking Server – experiment tracking and model artifact storage

MinIO – S3-compatible storage for MLflow artifacts

PostgreSQL – backend metadata store for MLflow

Prometheus PushGateway – metrics ingestion from training scripts

Grafana – visualization of experiment metrics

The infrastructure is deployed automatically via ArgoCD Applications.

Project Structure
mlops-experiments/
├── argocd/
│   ├── applications/
│   │   ├── mlflow.yaml
│   │   ├── minio.yaml
│   │   ├── postgres.yaml
│   │   └── pushgateway.yaml
├── experiments/
│   ├── train_and_push.py
│   └── requirements.txt
├── best_model/
│   └── <model> # will appear after successfull launch
└── README.md
Infrastructure Components
MLflow

Tracks experiments, parameters, metrics, and stores trained models.

MinIO

S3-compatible storage used by MLflow for storing artifacts.

PostgreSQL

Stores MLflow metadata (runs, experiments, metrics).

Prometheus PushGateway

Receives metrics pushed from training scripts.

Grafana

Visualizes metrics stored in Prometheus.

Deploy Infrastructure with ArgoCD

ArgoCD automatically deploys the following services from the argocd/applications directory:

MinIO

PostgreSQL

MLflow

Prometheus PushGateway

After syncing the ArgoCD application, Kubernetes will create all required resources.

To check deployments:

kubectl get pods -n application
kubectl get pods -n monitoring
Access Services via Port Forward

Because services run inside Kubernetes, we expose them locally.

MLflow
kubectl port-forward svc/mlflow 5000:5000 -n application

Open in browser:

http://localhost:5000
MinIO
kubectl port-forward svc/minio 9000:9000 -n application

Open:

http://localhost:9000

Credentials:

username: minio
password: minio123
Prometheus PushGateway
kubectl port-forward svc/pushgateway-prometheus-pushgateway 9091:9091 -n monitoring

Open:

http://localhost:9091
Running the Experiment Script

Navigate to the experiments directory:

cd experiments

Create virtual environment:

python -m venv venv

Activate environment:

Windows

venv\Scripts\activate

Linux / Mac

source venv/bin/activate

Install dependencies:

pip install -r requirements.txt
Environment Variables

Create .env file inside experiments/.

MLFLOW_TRACKING_URI=http://localhost:5000

AWS_ACCESS_KEY_ID=minio
AWS_SECRET_ACCESS_KEY=minio123

MLFLOW_S3_ENDPOINT_URL=http://localhost:9000

PUSHGATEWAY_URL=http://localhost:9091
Run Training Experiments

Run the training script:

python train_and_push.py

The script will:

Load the Iris dataset

Train models with different hyperparameters

Log parameters and metrics to MLflow

Save trained models as artifacts

Push metrics to Prometheus PushGateway

Identify the best model based on accuracy

Save the best model locally in best_model/

MLflow UI

Open:

http://localhost:5000

You will see:

experiment runs

parameters

metrics

model artifacts

View Metrics in Grafana

Open Grafana and go to:

Explore → Prometheus

Run queries:

mlflow_accuracy
mlflow_loss

These metrics are pushed from the training script via PushGateway.

Expected Results

After running experiments:

MLflow will display experiment runs

Metrics will be visible in Grafana

The best model will be saved locally:

best_model/
Screenshots
MLflow UI

(Add screenshot here)

Grafana Explore

(Add screenshot here)

ArgoCD Applications

(Add screenshot here)

MinIO Bucket

(Add screenshot here)

Technologies Used

Kubernetes

ArgoCD

MLflow

MinIO

PostgreSQL

Prometheus PushGateway

Grafana

Python

Scikit-learn