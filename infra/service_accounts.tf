# 1) İsteğe bağlı olarak SA oluştur
resource "google_service_account" "run_sa" {
  count        = var.create_runtime_sa ? 1 : 0
  account_id   = "api-run-${var.env}"
  display_name = "Cloud Run runtime (${var.env})"
}