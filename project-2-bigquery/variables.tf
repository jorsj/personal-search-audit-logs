variable "bigquery_project_id" {
  type        = string
  description = <<-EOT
    Proyecto 2 (Destino): ID del proyecto de GCP donde se crea el dataset de
    BigQuery que recibe los audit logs desde el Sink del Proyecto 1.
  EOT

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.bigquery_project_id))
    error_message = "bigquery_project_id debe ser un Project ID válido de GCP."
  }
}

variable "sink_writer_identity" {
  type        = string
  description = <<-EOT
    Identidad de escritura generada por el Sink en el Proyecto 1
    (`terraform -chdir=../project-1-sink output -raw sink_writer_identity`),
    con formato `serviceAccount:service-<PROJECT_1_NUMBER>@gcp-sa-logging.iam.gserviceaccount.com`.
  EOT

  validation {
    condition     = startswith(var.sink_writer_identity, "serviceAccount:")
    error_message = "sink_writer_identity debe comenzar con 'serviceAccount:' (ej. serviceAccount:service-123456@gcp-sa-logging.iam.gserviceaccount.com)."
  }
}

variable "bigquery_dataset_id" {
  type        = string
  description = <<-EOT
    ID del dataset de BigQuery en el Proyecto 2 donde Cloud Logging creará y
    poblará la tabla particionada `cloudaudit_googleapis_com_data_access`.
  EOT
  default     = "personal_search_audit_logs"

  validation {
    condition     = length(var.bigquery_dataset_id) <= 1024 && can(regex("^[a-zA-Z0-9_]+$", var.bigquery_dataset_id))
    error_message = "bigquery_dataset_id solo puede contener letras, números y guiones bajos."
  }
}

variable "bigquery_location" {
  type        = string
  description = "Ubicación del dataset de BigQuery en el Proyecto 2 (p. ej. US o us-central1)."
  default     = "US"
}
