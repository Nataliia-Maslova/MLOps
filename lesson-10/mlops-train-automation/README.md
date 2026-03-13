## MLOps AWS Step Functions Pipeline

This project demonstrates a simple MLOps pipeline using:

- AWS Lambda
- AWS Step Functions
- Terraform
- GitLab CI

## Architecture

Pipeline workflow:

ValidateData → LogMetrics

Step Functions orchestrates two Lambda functions.

## Project Structure


mlops-experiments/
terraform/
lambda/
validate.py
log_metrics.py
main.tf
variables.tf
outputs.tf


## Deployment

### 1 Create Lambda ZIP files

```bash
cd terraform/lambda

zip validate.zip validate.py
zip log_metrics.zip log_metrics.py
2 Initialize Terraform
cd ..
terraform init
3 Deploy infrastructure
terraform apply
4 Run pipeline
aws stepfunctions start-execution \
--state-machine-arn <ARN> \
--name test-run \
--input '{"source":"manual"}'
GitLab CI

GitLab pipeline triggers the Step Function automatically.

Required CI variables:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
STEP_FUNCTION_ARN
Cleanup

To avoid AWS charges:

terraform destroy