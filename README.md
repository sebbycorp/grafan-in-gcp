# GKE Cluster Terraform Configuration

This repository contains Terraform configurations to deploy a Google Kubernetes Engine (GKE) cluster in Google Cloud Platform.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed (version >= 1.0)
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
3. A Google Cloud Project with billing enabled
4. Authenticated with Google Cloud (`gcloud auth application-default login`)

## Project Structure

```
.
├── terraform/
│   ├── main.tf         - Main Terraform configuration file
│   ├── variables.tf    - Variable definitions
│   ├── provider.tf     - Provider configuration
│   ├── outputs.tf      - Output definitions
│   └── terraform.tfvars - (Optional) Variable values
└── README.md
```

## Usage

1. Change to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

## Default Configuration

The configuration creates:
- A GKE cluster with the name "grafana-gke-cluster"
- A node pool with 2 nodes
- Each node uses e2-medium machine type
- 100GB disk size per node
- Located in us-central1 region

## Customization

You can customize the deployment by:
1. Creating a `terraform.tfvars` file with your desired values
2. Or passing variables directly via command line:
   ```bash
   terraform apply -var="gke_num_nodes=3" -var="machine_type=e2-large"
   ```

## Connecting to the Cluster

After applying the Terraform configuration, you can connect to your cluster in two ways:

1. Using the gcloud command (recommended):
   ```bash
   gcloud container clusters get-credentials grafana-gke-cluster --region us-central1
   ```

2. Or using the output command from Terraform:
   ```bash
   terraform output get_credentials_command
   ```

## Important Notes

- Make sure you have the necessary IAM permissions in your GCP project
- The configuration uses a custom service account for the GKE nodes
- Logging and monitoring are enabled by default
- The cluster's connection information is available in the Terraform outputs