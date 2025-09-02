variable "project_id" {}
variable "region"     { default = "europe-west3" }
variable "env"        { description = "dev or prod" }
variable "service_base_name" { default = "bitewise-api" }

# Yeni: build edilen imaj referansı (tag ya da digest ile)
variable "image" {
  description = "Full image ref in Artifact Registry (e.g. europe-west3-docker.pkg.dev/PROJECT/app-repo/bitewise-api:SHA or @sha256:...)"
  type        = string
  default     = null
}

variable "manage_repo" {
  description = "Artifact Registry reposunu Terraform oluştursun mu?"
  type        = bool
  default     = false   # dev'de false, prod'da true
}

variable "create_runtime_sa" {
  description = "Cloud Run runtime SA'yı Terraform oluştursun mu?"
  type        = bool
  default     = false   # dev'de false, prod'da true (veya bootstrap koşusunda)
}

variable "runtime_sa_email" {
  description = "Oluşturulmayacaksa kullanılacak mevcut SA e-mail"
  type        = string
  default     = null
}

