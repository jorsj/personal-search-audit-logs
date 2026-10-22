output "bigquery_project_id" {
  description = "Proyecto 2 (Destino): donde vive el dataset y la tabla de BigQuery."
  value       = var.bigquery_project_id
}

output "bigquery_dataset_id" {
  description = "ID del dataset de BigQuery en el Proyecto 2."
  value       = google_bigquery_dataset.audit_logs.dataset_id
}

output "bigquery_table" {
  description = "Tabla particionada en BigQuery (Proyecto 2) donde se escriben los audit logs de búsquedas y apertura de documentos."
  value       = "${var.bigquery_project_id}.${google_bigquery_dataset.audit_logs.dataset_id}.cloudaudit_googleapis_com_data_access"
}

output "sink_writer_identity" {
  description = "Identidad del Sink del Proyecto 1 autorizada con roles/bigquery.dataEditor sobre el dataset."
  value       = google_bigquery_dataset_iam_member.sink_writer.member
}
