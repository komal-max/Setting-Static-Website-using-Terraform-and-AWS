#using this to create s3 bucket

resource "aws_s3_bucket" "bucket3" {
  bucket = var.mybucketname

}

#define ownership of the bucket

resource "aws_s3_bucket_ownership_controls" "own-1" {
  bucket = aws_s3_bucket.bucket3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#make bucket public

resource "aws_s3_bucket_public_access_block" "public-1" {
  bucket = aws_s3_bucket.bucket3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#acl

resource "aws_s3_bucket_acl" "acl-1" {
  depends_on = [
    aws_s3_bucket_ownership_controls.own-1,
    aws_s3_bucket_public_access_block.public-1,
  ]

  bucket = aws_s3_bucket.bucket3.id
  acl    = "public-read"
}


resource "aws_s3_object" "index-1" {
  bucket = aws_s3_bucket.bucket3.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_object" "error-1" {
  bucket = aws_s3_bucket.bucket3.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_object" "profile-1" {
    bucket = aws_s3_bucket.bucket3.id
    key = "my-profile.jpeg"
    source = "my-profile.jpeg"
    acl = "public-read"
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.bucket3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.acl-1]

  
}

