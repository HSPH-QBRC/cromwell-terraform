## Cromwell provisioner with Terraform

This repository contains a Terraform plan for creating a new VM on Google Cloud Project and provisioning it to run a Cromwell server. Note that this plan exposes the Cromwell server with an ephemeral public IP on port 8000. If you require additional security, such as limiting connections to known IPs or sources, make changes to the terraform plan accordingly.

**To use**

- Create a service account (via gcloud or web console) and download the JSON key file to your machine. Ensure this service account has appropriate permissions. We typically use a service account with owner permissions, but more restrictive service accounts may be possible.

- Create a `terraform.tfvars` file based on the provided `terraform.tfvars.template` file. Fill in your GCP details and service account key, etc.

- Run `terraform init` and `terraform apply`

Also, note that you may need to enable additional Google services if this is your first time running a Cromwell server within your GCP project. For instance, the Cloud Life Sciences API should be enabled. Your enabled services can be managed at https://console.cloud.google.com/apis/dashboard

