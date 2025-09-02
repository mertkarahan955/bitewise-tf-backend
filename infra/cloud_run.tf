resource "google_cloud_run_v2_service" "svc" {
  name     = local.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.run_sa.email

    containers {
      image = local.image_ref

      ports {
        container_port = 8080
      }

      env {
        name  = "STAGE"
        value = var.env
      }
    }
  }

  depends_on = [google_artifact_registry_repository.repo]
}

# Public erişim (test için)
resource "google_cloud_run_v2_service_iam_member" "invoker_all" {
  name     = google_cloud_run_v2_service.svc.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
