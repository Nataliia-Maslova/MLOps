terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

########################################
# IAM ROLE FOR LAMBDA
########################################

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_mlops"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

########################################
# LAMBDA FUNCTIONS
########################################

resource "aws_lambda_function" "validate" {
  filename         = "lambda/validate.zip"
  function_name    = "validateData"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "validate.handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda/validate.zip")
}

resource "aws_lambda_function" "log_metrics" {
  filename         = "lambda/log_metrics.zip"
  function_name    = "logMetrics"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "log_metrics.handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda/log_metrics.zip")
}

########################################
# STEP FUNCTION ROLE
########################################

resource "aws_iam_role" "stepfunction_exec" {
  name = "stepfunction_exec_role_mlops"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "stepfunction_lambda_invoke" {
  name = "stepfunction_lambda_invoke"
  role = aws_iam_role.stepfunction_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = "*"
      }
    ]
  })
}

########################################
# STEP FUNCTION
########################################

resource "aws_sfn_state_machine" "mlops_pipeline" {
  name     = "MLOpsPipeline"
  role_arn = aws_iam_role.stepfunction_exec.arn

  definition = jsonencode({
    StartAt = "ValidateData",
    States = {

      ValidateData = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = aws_lambda_function.validate.arn,
          Payload.$ = "$"
        },
        Next = "LogMetrics"
      },

      LogMetrics = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = aws_lambda_function.log_metrics.arn,
          Payload.$ = "$"
        },
        End = true
      }

    }
  })
}