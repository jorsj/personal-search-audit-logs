output "app_project_id" {
  description = "Proyecto 1 (Origen): donde vive Personal Search y el Cloud Logging Sink."
  value       = var.app_project_id
}

output "sink_name" {
  description = "Nombre del Cloud Logging Sink creado en el Proyecto 1."
  value       = google_logging_project_sink.audit_logs.name
}

output "sink_writer_identity" {
  description = <<-EOT
    Identidad del Sink en el Proyecto 1 (`serviceAccount:service-<PROJECT_1_NUMBER>@gcp-sa-logging.iam.gserviceaccount.com`).
    Pasa este valor como `sink_writer_identity` al Terraform de `project-2-bigquery`.
  EOT
  value       = google_logging_project_sink.audit_logs.writer_identity
}

output "sink_destination" {
  description = "URI del dataset de BigQuery en el Proyecto 2 al que apunta el Sink."
  value       = google_logging_project_sink.audit_logs.destination
}

output "sink_filter" {
  description = "Filtro aplicado en el Sink (búsquedas en Discovery Engine y lecturas de PDFs en GCS)."
  value       = google_logging_project_sink.audit_logs.filter
}
