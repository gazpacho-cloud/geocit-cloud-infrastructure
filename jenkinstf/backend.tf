terraform {
  backend "gcs" {
    bucket = "stuff-bucket-tfstate"
    prefix = "terraform/jenkinsstate"
  }
}