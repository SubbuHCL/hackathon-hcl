provider "aws" {
  region = "us-east-1"
}
module "aws_iam_role"   {
    source = "./modules/IAM"
    name = "lambda_exec_role_hello_world"
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

module "aws_iam_role_policy_attachment"  {
  source = "./modules/IAM"
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
module "aws_lambda_function" {
  source = "./modules/LAMDA"
  function_name = "hello-world-function"
  role          = "arn:aws:iam::539935451710:role/lambda_exec_role_hello_world"
  image_uri     = "183114607892.dkr.ecr.us-west-2.amazonaws.com/helloword-service:latest"
  package_type  = "Image"
  environment {
    variables = {
      NODE_ENV = "production"
    }
  }
}


module "aws_ecr_repository"  {
  source = "./modules/ECR"
  name = "my-app-repo"
}