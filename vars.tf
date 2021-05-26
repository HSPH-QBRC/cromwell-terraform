variable "project_id" {
  description = "GCP project ID. This is the text-based ID, not the numeric ID."
}

variable "region" {
  default = "us-east4"
}

variable "zone" {
  default = "us-east4-c"
}

variable "credentials_file" {
  description = "Path to JSON file with GCP service account key"
}

variable "cromwell_machine_config" {
  type    = object({
                machine_type   = string
                disk_size_gb   = number
            })
  default = {
    machine_type = "e2-standard-2"
    disk_size_gb = 20
  }
}

variable "cromwell_os_image" {
  description = "The operating system to use with the Cromwell VM"
  default = "ubuntu-2004-focal-v20210325"
}

variable "cromwell_bucket" {
  description = "Name of the bucket where Cromwell will place its files. Do NOT include the gs prefix."
}

variable "cromwell_db_name" {
  description = "The name of the database."
  type        = string
  sensitive   = true
}

variable "cromwell_db_user" {
  description = "The database user."
  type        = string
  sensitive   = true
}

variable "cromwell_db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "service_account_email" {
  description = "The email-like identifier of the service account attached to the VM instance. Must have adequate permissions."
}