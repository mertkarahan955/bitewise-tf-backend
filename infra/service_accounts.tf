resource "google_service_account" "run_sa" {
  account_id   = "api-run-${var.env}"
  display_name = "Cloud Run runtime (${var.env})"
}

# Mevcut GitHub deployer SA'yı data ile bul
data "google_service_account" "deployer" {
  project    = var.project_id
  account_id = "github-deployer"
}
