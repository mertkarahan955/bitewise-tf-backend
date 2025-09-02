data "google_artifact_registry_repository" "repo" {
  count         = var.manage_repo ? 0 : 1
  location      = var.region
  repository_id = "app-repo"
}