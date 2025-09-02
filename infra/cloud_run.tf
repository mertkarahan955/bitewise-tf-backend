resource "google_cloud_run_v2_service" "svc" {
  name     = local.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = local.run_sa_email
    containers {
      image = local.image_ref
      ports { container_port = 8080 }
      env   {
          name = "STAGE"
          value = var.env
      }
    }
  }
}
