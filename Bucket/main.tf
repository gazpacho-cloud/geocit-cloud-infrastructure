resource "google_storage_bucket" "default" {
  name          = "stuff-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
