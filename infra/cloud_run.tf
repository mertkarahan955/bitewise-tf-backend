resource "google_cloud_run_v2_service" "svc" {
  name     = local.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = data.google_service_account.run_sa.email
    containers {
      image = local.image_ref
      ports { container_port = 8080 }
      env {
        name  = "STAGE"
        value = var.env
      }
    }
  }
}
