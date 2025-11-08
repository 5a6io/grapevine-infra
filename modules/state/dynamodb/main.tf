# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "state_lock" {
  name         = "${var.name}-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.common_tags, {
    Name    = "${var.name}-tf-lock"
  })
}