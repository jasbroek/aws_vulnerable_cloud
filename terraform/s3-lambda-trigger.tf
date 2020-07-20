# Create Lambda bucket.
# 
# This bucket triggers a Lambda function when a .zip is put into the Upload directory
# Can be exploited as Lambda is vulnerable to code injection.

# The bucket itself
resource "aws_s3_bucket" "lambda" {
  bucket = lower("fc-lambda-bucket-${var.unique_id}")
  acl    = "public-read-write"
  force_destroy = true
  tags = {
    Name        = "Lambda Bucket"
    Environment = "Production"
  }
}

# Put something inside the 'uploads' folder
resource "aws_s3_bucket_object" "zip_upload" {
  bucket = aws_s3_bucket.lambda.id
  key    = "Uploads/TriggerLambda.zip"
  source = "../assets/files/lambdaTrigger.zip"

  acl = "public-read"
}



# Allow the bucket to invoke the specific Lambda function
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fc-lambda-function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda.arn
}

# Say 'this bucket action should invoke this Lambda function'
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.lambda.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.fc-lambda-function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "Uploads/"
    filter_suffix       = ".zip"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}