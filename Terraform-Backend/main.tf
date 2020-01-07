provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/navaneethreddy/.aws/credentials"
  profile                 = "default"
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-statefiles-bucket"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-statefiles-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#####Variables are not allowed in backend configuration
terraform{
  backend "s3" {
    bucket ="terraform-statefiles-bucket"
    key ="Statefiles/"
    region ="us-east-1"

    dynamodb_table="terraform-statefiles-locks"
    encrypt ="true"

  }
}


