variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "devops-ecr-pipeline-repo"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "ecr-push-handler"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "ecr-push-notifications"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "ecr-events"
}

variable "email_subscription" {
  description = "Email address for SNS subscription"
  type        = string
  default     = "your-email@example.com" # Replace with actual email
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "devops-ecr-pipeline"
    Environment = "dev"
  }
}