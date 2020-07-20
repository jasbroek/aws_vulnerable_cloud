# Create a secret bucket and log bucket

# Create the log bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = lower("fc-log-bucket-${var.unique_id}")
  acl    = "private"

  tags = {
    Name        = "FC Bucket"
    Environment = "Dev"
  }
}

# Create a private bucket to be exploited by EC2 and Lambda
resource "aws_s3_bucket" "fc_bucket" {
  bucket = lower("MySecretBucket-${var.unique_id}")
  acl    = "private"

  tags = {
    Name        = "Secret Bucket"
    Environment = "Dev"
  }
}

# Put a file containing fake passwords inside
resource "aws_s3_bucket_object" "fc_secret_files" {
  bucket = aws_s3_bucket.fc_bucket.id
  key = "secrets.txt"
  source = "../assets/files/secrets.txt"
  content_type = "text/plain; charset=utf-8"
  tags = {
    Name = "Bucket Secrets"
  }

  acl = "private"
}

# Put a file containing fake PII inside
resource "aws_s3_bucket_object" "secret_auth_secret_files" {
  bucket = aws_s3_bucket.fc_bucket.id
  key = "Data/extra_secure_pii.csv"
  source = "../assets/files/us-500-pii.csv"
  content_type = "text/csv; charset=utf-8"
  tags = {
    Name = "Authenticated PII"
  }

  acl = "authenticated-read"
}