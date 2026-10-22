# ---------------------------------------------------------------------------
# Proyecto 2 (Destino): Dataset de BigQuery y Permiso IAM para el Sink
#
# Este módulo opera exclusivamente sobre `var.bigquery_project_id` (Proyecto 2).
# Crea el dataset de BigQuery y autoriza con `roles/bigquery.dataEditor` al
# `sink_writer_identity` del Cloud Logging Sink creado en el Proyecto 1.
# ---------------------------------------------------------------------------

locals {
  required_apis = toset([
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
  ])
}

# 1. Activación de APIs en el Proyecto 2
resource "google_project_service" "apis" {
  for_each = local.required_apis

  project            = var.bigquery_project_id
  service            = each.value
  disable_on_destroy = false
}

# 2. Dataset de BigQuery donde Cloud Logging escribe `cloudaudit_googleapis_com_data_access`
resource "google_bigquery_dataset" "audit_logs" {
  project       = var.bigquery_project_id
  dataset_id    = var.bigquery_dataset_id
  friendly_name = "Personal Search User Action Audit Logs"
  description   = "Audit logs (DATA_READ) de búsquedas (Discovery Engine) y apertura de documentos (GCS) de Personal Search."
  location      = var.bigquery_location

  labels = {
    app = "personal-search"
  }

  depends_on = [
    google_project_service.apis,
  ]
}

# 3. Permiso de escritura en el dataset para el Sink del Proyecto 1
resource "google_bigquery_dataset_iam_member" "sink_writer" {
  project    = var.bigquery_project_id
  dataset_id = google_bigquery_dataset.audit_logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = var.sink_writer_identity
}
