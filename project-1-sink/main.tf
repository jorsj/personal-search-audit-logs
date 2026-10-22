# ---------------------------------------------------------------------------
# Proyecto 1 (Origen): Habilitación de Audit Logs (DATA_READ) y Sink
#
# Este módulo opera exclusivamente sobre `var.app_project_id` (Proyecto 1).
# Captura solo las dos acciones necesarias para medir búsquedas y CTR de
# apertura de documentos en Personal Search:
#   1. Buscar:           discoveryengine.googleapis.com -> SearchService.Search
#   2. Abrir documento:  storage.googleapis.com         -> storage.objects.get
# ---------------------------------------------------------------------------

locals {
  sink_filter = <<-EOT
    log_id("cloudaudit.googleapis.com/data_access")
    AND (
      (
        protoPayload.serviceName="discoveryengine.googleapis.com" AND
        protoPayload.methodName="google.cloud.discoveryengine.v1.SearchService.Search"
      )
      OR (
        protoPayload.serviceName="storage.googleapis.com" AND
        protoPayload.methodName="storage.objects.get"
      )
    )
  EOT

  audit_config_services = toset([
    "discoveryengine.googleapis.com",
    "storage.googleapis.com",
  ])

  required_apis = toset([
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "discoveryengine.googleapis.com",
    "storage.googleapis.com",
  ])
}

# 1. Activación de APIs en el Proyecto 1
resource "google_project_service" "apis" {
  for_each = local.required_apis

  project            = var.app_project_id
  service            = each.value
  disable_on_destroy = false
}

# 2. Habilitación de Data Access Audit Logs (DATA_READ) para Discovery Engine y GCS
resource "google_project_iam_audit_config" "user_actions" {
  for_each = local.audit_config_services

  project = var.app_project_id
  service = each.value

  audit_log_config {
    log_type = "DATA_READ"
  }

  depends_on = [
    google_project_service.apis,
  ]
}

# 3. Cloud Logging Sink en el Proyecto 1 apuntando al dataset en el Proyecto 2
resource "google_logging_project_sink" "audit_logs" {
  project     = var.app_project_id
  name        = var.sink_name
  description = "Exporta los Data Access Audit Logs de búsqueda (Discovery Engine) y apertura de documentos (GCS) hacia BigQuery en ${var.bigquery_project_id}:${var.bigquery_dataset_id}."

  destination = "bigquery.googleapis.com/projects/${var.bigquery_project_id}/datasets/${var.bigquery_dataset_id}"
  filter      = local.sink_filter

  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }

  depends_on = [
    google_project_service.apis,
  ]
}
