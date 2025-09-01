resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}


# Artifact Registry (Docker)
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "app-repo"
  format        = "DOCKER"
  depends_on    = [google_project_service.services]
}

# Service Accounts
resource "google_service_account" "run_sa" {
  account_id   = "api-run-${var.env}"
  display_name = "Cloud Run runtime (${var.env})"
}

# Mevcut GitHub deployer SA'yı data ile bul
data "google_service_account" "deployer" {
  project    = var.project_id
  account_id = "github-deployer"
}

# IAM (deployer)
resource "google_project_iam_member" "run_admin" {
  role    = "roles/run.admin"
  project = var.project_id
  member  = "serviceAccount:${data.google_service_account.deployer.email}"
}
resource "google_project_iam_member" "ar_writer" {
  role    = "roles/artifactregistry.writer"
  project = var.project_id
  member  = "serviceAccount:${data.google_service_account.deployer.email}"
}
resource "google_project_iam_member" "sa_user" {
  role    = "roles/iam.serviceAccountUser"
  project = var.project_id
  member  = "serviceAccount:${data.google_service_account.deployer.email}"
}

locals {
  service_name = var.env == "prod" ? var.service_base_name : "${var.service_base_name}-${var.env}"

  # image verilmediyse 'latest' varsayılanı (not: prod için sabit tag önerilmez)
  default_image = "${var.region}-docker.pkg.dev/${var.project_id}/app-repo/${var.service_base_name}:latest"
  image_ref     = var.image != null ? var.image : local.default_image
}

resource "google_cloud_run_v2_service" "svc" {
  name     = local.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.run_sa.email
    containers {
      image = local.image_ref
      ports { container_port = 8080 }
      env {
        name = "STAGE"
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

output "service_name" { value = local.service_name }
output "service_url" { value = google_cloud_run_v2_service.svc.uri }
output "repo_url" { value = "${var.region}-docker.pkg.dev/${var.project_id}/app-repo" }