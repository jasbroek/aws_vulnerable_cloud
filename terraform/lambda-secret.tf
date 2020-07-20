# Create vuln lambda function with secrets
resource "aws_lambda_function" "secret" {
  filename = "../assets/scripts/lambda_secret.zip"
  function_name = "lambda-admin-test-${var.unique_id}"
  role = aws_iam_role.fc-lambda-role.arn
  handler = "lambda_function.handler"
  source_code_hash = data.archive_file.lambda-secret.output_base64sha256
  runtime = "python3.7"
  environment {
      variables = {
          ADMIN_ACCESS = "${aws_iam_access_key.eve.id}"
          ADMIN_SECRET = "${aws_iam_access_key.eve.secret}"
      }
  }
  tags = {
    Name = "admin-lambda"
  }
}
