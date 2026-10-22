variable "app_project_id" {
  type        = string
  description = <<-EOT
    Proyecto 1 (Origen): ID del proyecto de GCP donde vive el stack de
    Personal Search y donde se configuran los Audit Logs y el Cloud Logging Sink.
  EOT

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.app_project_id))
    error_message = "app_project_id debe ser un Project ID válido de GCP."
  }
}

variable "bigquery_project_id" {
  type        = string
  description = <<-EOT
    Proyecto 2 (Destino): ID del proyecto de GCP donde vive el dataset de
    BigQuery al que apuntará el destino del Sink.
  EOT

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.bigquery_project_id))
    error_message = "bigquery_project_id debe ser un Project ID válido de GCP."
  }
}

variable "bigquery_dataset_id" {
  type        = string
  description = "ID del dataset de BigQuery en el Proyecto 2 al que enviará eventos el Sink."
  default     = "personal_search_audit_logs"

  validation {
    condition     = length(var.bigquery_dataset_id) <= 1024 && can(regex("^[a-zA-Z0-9_]+$", var.bigquery_dataset_id))
    error_message = "bigquery_dataset_id solo puede contener letras, números y guiones bajos."
  }
}

variable "sink_name" {
  type        = string
  description = "Nombre del Cloud Logging Sink en el Proyecto 1."
  default     = "personal-search-audit-logs-to-bq"
}
