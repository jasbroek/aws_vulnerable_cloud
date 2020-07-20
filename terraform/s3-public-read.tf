#
#   Create the public readable bucket with a simple 'website'
#

# The bucket itself
resource "aws_s3_bucket" "fc_web_bucket" {
  bucket = lower("fc-web-bucket-${var.unique_id}")
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "FC Bucket"
    Environment = "Dev"
  }
}

# Put a public secret file in
resource "aws_s3_bucket_object" "web_secret_files" {
  bucket = aws_s3_bucket.fc_web_bucket.id
  key = "Secret/secrets.txt"
  source = "../assets/files/secrets.txt"
  content_type = "text/plain; charset=utf-8"
  tags = {
    Name = "Bucket Secrets"
  }

  acl = "public-read"
}

# Put a authenticated-read file in
resource "aws_s3_bucket_object" "web_auth_secret_files" {
  bucket = aws_s3_bucket.fc_web_bucket.id
  key = "Authenticated/extra_secure_pii.csv"
  source = "../assets/files/us-500-pii.csv"
  content_type = "text/csv; charset=utf-8"
  tags = {
    Name = "Authenticated PII"
  }

  acl = "authenticated-read"
}

# Put the 'website' files in
resource "aws_s3_bucket_object" "web_files" {
  for_each = fileset("../assets/www", "*.html")

  bucket = aws_s3_bucket.fc_web_bucket.id
  key    = each.value
  source = "../assets/www/${each.value}"

  content_type = "text/html; charset=utf-8"
  acl = "public-read"
}
