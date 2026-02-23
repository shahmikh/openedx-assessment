terraform {
  backend "s3" {
    bucket         = "CHANGE_ME_STATE_BUCKET"
    key            = "openedx/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "CHANGE_ME_STATE_LOCK"
    encrypt        = true
  }
}
