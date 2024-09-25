terraform {
  backend "s3" {
    bucket = "mk-dev-statefile"
    key    = "dev-terraform.tfstate"
    region = "ap-south-1"
  }
}