provider "aws" {
  region = "eu-central-1"
}

data "aws_s3_bucket" "existing_state_bucket" {
  bucket = "terraform-statefile"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-statefile"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-state"
    Environment = "dev"
  }

  count = length([for b in data.aws_s3_bucket.existing_state_bucket: b.id]) == 0 ? 1 : 0
}

data "aws_dynamodb_table" "existing_lock_table" {
  name = "terraform-lock"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-lock"
    Environment = "dev"
  }

  count = length([for t in data.aws_dynamodb_table.existing_lock_table: t.id]) == 0 ? 1 : 0
}
