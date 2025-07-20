variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket for file uploads"
}

variable "lambda_function_name" {
  description = "Lambda function name"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
}
