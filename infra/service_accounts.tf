resource "google_service_account" "run_sa" {
  account_id   = "api-run-${var.env}"
  display_name = "Cloud Run runtime (${var.env})"
}

data "google_service_account" "run_sa" {
  project    = var.project_id
  account_id = "api-run-${var.env}"
}
