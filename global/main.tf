resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
depends_on = [aws_s3_bucket_ownership_controls.ownership]

  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
  name    = "${var.bucket_name}-lock-table"
  read_capacity = 1
  write_capacity = 1

  tags = {
    description = "DynamoDB table for Terraform state locking"
    Terraform = "true"
  }
}