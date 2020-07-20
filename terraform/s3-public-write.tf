# 
#   Create the public writable bucket with a 'donate' website
# 


# The bucket itself
resource "aws_s3_bucket" "writable_bucket" {
  bucket = lower("fc-content-bucket-${var.unique_id}")
  acl    = "public-read-write"
  force_destroy = true
  
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Content Bucket"
    Environment = "Production"
  }
}

# Put the website file in
resource "aws_s3_bucket_object" "content_files" {
  bucket = aws_s3_bucket.writable_bucket.id

  key    = "index.html"
  source = "../assets/www/donation-site/index.html"

  content_type = "text/html; charset=utf-8"
  acl = "public-read-write"
}