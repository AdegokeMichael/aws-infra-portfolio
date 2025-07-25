output "s3_bucket_name" {
  value = module.s3.bucket_id
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}
