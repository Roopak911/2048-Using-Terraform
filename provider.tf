# configure aws provider
provider "aws" {
  region  = var.region
  profile = "roopak"
}

# configure backend
terraform {
  backend "s3" {
    bucket         = "game-2048-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    profile        = "roopak"
    dynamodb_table = "game-2048-state-lock-dynamodb"
  }
}
