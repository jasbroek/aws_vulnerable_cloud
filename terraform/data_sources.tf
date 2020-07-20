#AWS Account Id
data "aws_caller_identity" "aws-account-id" {
  
}

# Get the lates ubuntu AMI
data "aws_ami" "ubuntu-18-server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Amazon itself
}

# S3 full access policy
data "aws_iam_policy" "s3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Zip file for Lambda function
data "archive_file" "fc-lambda-function" {
  type = "zip"
  source_file = "../assets/scripts/lambda_function.py"
  output_path = "../assets/scripts/lambda_function.zip"
}

# Zip file for Lambda function
data "archive_file" "lambda-secret" {
  type = "zip"
  source_file = "../assets/scripts/lambda_secret.py"
  output_path = "../assets/scripts/lambda_secret.zip"
}
