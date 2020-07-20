resource "aws_iam_role" "fc-lambda-role" {
  name = "fc-lambda-role-service-role-${var.unique_id}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "fc-lambda-role-${var.unique_id}"
  }
}

# Define policy for bucket access
resource "aws_iam_policy" "lambda-s3" {
  name        = "lambda-s3"
  description = "This policy gives limited read access to s3 buckets."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:Get*",
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.lambda.arn}",
        "${aws_s3_bucket.fc_bucket.arn}"
      ]
    },
    {
      "Action": "s3:ListAllMyBuckets",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Give lambda access to S3
resource "aws_iam_role_policy_attachment" "lambda_s3_full_access" {
  role       = aws_iam_role.fc-lambda-role.name
  policy_arn = aws_iam_policy.lambda-s3.arn
}

# Create vuln lambda function with secrets
resource "aws_lambda_function" "fc-lambda-function" {
  filename = "../assets/scripts/lambda_function.zip"
  function_name = "s3-zip-counter-${var.unique_id}"
  role = aws_iam_role.fc-lambda-role.arn
  handler = "lambda_function.handler"
  source_code_hash = data.archive_file.fc-lambda-function.output_base64sha256
  runtime = "python3.7"
  environment {
      variables = {
          EC2_ACCESS_KEY_ID = "SOME ACCESS KEY"
          EC2_SECRET_KEY_ID = "SOME SECRET KEY"
          CORE_EXACT_DEPLOY_KEY = "ABCDEFGHIJKLMNOPQRSTUVW1234567890!"
      }
  }
  tags = {
    Name = "vuln-lambda"
  }
}
