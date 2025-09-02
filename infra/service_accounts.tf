# 1) İsteğe bağlı olarak SA oluştur
resource "google_service_account" "run_sa" {
  count        = var.create_runtime_sa ? 1 : 0
  account_id   = "api-run-${var.env}"
  display_name = "Cloud Run runtime (${var.env})"
}

# 2) SA'yı okumayı da koşullu yap:
# - SA oluşturulmuyorsa VE runtime_sa_email verilmemişse
#   mevcut "api-run-${var.env}" isimli SA'yı projeden bul.
data "google_service_account" "run_sa" {
  count      = (!var.create_runtime_sa && var.runtime_sa_email == null) ? 1 : 0
  project    = var.project_id
  account_id = "api-run-${var.env}"
}

# 3) Tek doğru e-posta: oluşturulandan, ya da var.runtime_sa_email,
#    o da yoksa data'dan çek.
locals {
  run_sa_email = var.create_runtime_sa
    ? google_service_account.run_sa[0].email
    : (var.runtime_sa_email != null
        ? var.runtime_sa_email
        : data.google_service_account.run_sa[0].email)
}
