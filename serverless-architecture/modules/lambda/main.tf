resource "aws_iam_role" "this" {
  name = "${var.lambda_function_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}


resource "aws_lambda_function" "this" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.this.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename         = "${path.root}/lambda/lambda.zip"
  source_code_hash = filebase64sha256("${path.root}/lambda/lambda.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.this.arn
}
