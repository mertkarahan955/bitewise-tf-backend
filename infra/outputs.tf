output "service_name" { value = local.service_name }
output "service_url"  { value = google_cloud_run_v2_service.svc.uri }
output "repo_url"     { value = "${var.region}-docker.pkg.dev/${var.project_id}/app-repo" }
