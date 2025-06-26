terraform {
  backend "s3" {
    bucket = "tf-bucket-prod1"
    key    = "uc16-17-semantic/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    #use_lockfile = true
  }
}