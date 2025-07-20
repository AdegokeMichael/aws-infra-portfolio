variable "lambda_function_name" {
  description = "Name for the Lambda function"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table to store file metadata"
}

variable "s3_bucket_arn" {}
