
resource "google_service_account" "siteverifier" {
  account_id   = "google-site-verifier"
  display_name = "Google Site verification account"
}

resource "google_service_account_key" "siteverifier" {
  service_account_id = google_service_account.siteverifier.name
}
