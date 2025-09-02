locals {
  service_name  = var.env == "prod" ? var.service_base_name : "${var.service_base_name}-${var.env}"
  default_image = "${var.region}-docker.pkg.dev/${var.project_id}/app-repo/${var.service_base_name}:latest"
  image_ref     = var.image != null ? var.image : local.default_image
}
