terraform {
  backend "gcs" {
    bucket = "tfstate-bitewise-470710" # kendi bucket adın
    prefix = "diet-backend"            # sabit klasör; workspace'ler bunun altında oluşur
  }
}