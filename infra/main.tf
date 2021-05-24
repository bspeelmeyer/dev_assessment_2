provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "rmit-tfstate-a3n15z"
    key            = "terraform-remote-state-file/"
    region         = "us-east-1"
    dynamodb_table = "RMIT-locktable-a3n15z"
  }
}
