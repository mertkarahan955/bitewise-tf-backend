# run_iam.tf
variable "public_invoker" {
  type        = bool
  description = "Cloud Run servisine anonim erişim verilsin mi?"
  default     = true
}

resource "google_cloud_run_v2_service_iam_member" "invoker_all" {
  count    = var.public_invoker ? 1 : 0
  project  = var.project_id
  name     = google_cloud_run_v2_service.svc.name   # örn: bitewise-api-dev / bitewise-api
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [google_cloud_run_v2_service.svc]
}
