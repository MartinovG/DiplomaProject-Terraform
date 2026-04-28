resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key     = "LockID"
  name         = "${var.bucket_name}-lock-table"
  billing_mode = "PAY_PER_REQUEST"

  tags = {
    description = "DynamoDB table for Terraform state locking"
    Terraform   = "true"
  }
}