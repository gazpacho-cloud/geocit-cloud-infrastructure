resource "google_storage_bucket" "default" {
  name          = "stuff-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  # encryption {
  #   default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  # }
  # depends_on = [
  #   google_project_iam_member.default
  # ]
}

# resource "google_kms_key_ring" "terraform_state_bucket_key_ring" {
#   name     = "terraform-state-key-ring-2"
#   location = "US"
# }

# resource "google_kms_crypto_key" "terraform_state_bucket" {
#   name            = "terraform-state-key"
#   key_ring        = google_kms_key_ring.terraform_state_bucket_key_ring.id
#   rotation_period = "100000s"

#   lifecycle {
#     prevent_destroy = false
#   }
# }