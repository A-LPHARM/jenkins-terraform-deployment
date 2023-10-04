terraform {
  backend "s3" {
    bucket = "terraformhenrystatefile"
    key    = "henryproject.tfstate"
    region = "us-east-1"
    profile = "terraformprofile"
  }
}
