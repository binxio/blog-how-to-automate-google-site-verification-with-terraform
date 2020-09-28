provider googlesiteverification {
  credentials = base64decode(google_service_account_key.siteverifier.private_key)
}

provider google {
  project = var.project
}

provider aws {
}
