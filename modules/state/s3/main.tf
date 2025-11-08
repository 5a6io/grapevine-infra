# s3
resource "aws_s3_bucket" "state" {
  bucket = "${var.name}-tfstate-bucket"
  tags = merge(var.common_tags, {
    Name    = "${var.name}-tfstate-bucket"
  })
}

# S3 버킷 기본 설정 (암호화, 버저닝, 차단 정책)
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}