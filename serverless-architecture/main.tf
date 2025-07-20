module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  lambda_function_arn = module.lambda.lambda_function_arn
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  dynamodb_table_name  = module.dynamodb.table_name
  s3_bucket_arn        = module.s3.bucket_arn
}

resource "aws_s3_bucket_notification" "this" {
  bucket = module.s3.bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.lambda]
}
