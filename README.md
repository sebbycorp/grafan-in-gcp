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

# OpenTelemetry Collector Setup Guide

This repository contains the configuration for running OpenTelemetry Collector with F5 BIG-IP monitoring capabilities.

## Architecture Overview

- **On-premises**: OpenTelemetry Collector with BIG-IP receiver running in Docker
- **GCP**: Kubernetes-hosted OpenTelemetry Collector that receives data and exports to Prometheus
- **Monitoring**: Prometheus for metrics storage and Grafana for visualization

## Running OpenTelemetry Collector On-Premises

Follow these steps to run the OpenTelemetry Collector on a Linux server with Docker already installed.

### 1. Create the directory structure

```bash
mkdir -p onprem-otel/config
mkdir -p onprem-otel/scripts
```

### 2. Create the collector configuration file

```bash
nano onprem-otel/config/otel-config.yaml
```

### 3. Add this configuration

Adjust with your BIG-IP details and GCP collector IP:

```yaml
receivers:
  bigip:
    endpoint: "https://YOUR_BIGIP_IP"
    username: "${env:BIGIP_USERNAME}"
    password: "${env:BIGIP_PASSWORD}"
    collection_interval: 60s
    tls:
      insecure_skip_verify: true
    data_types:
      f5.system:
        enabled: true
      f5.ltm:
        enabled: true

processors:
  batch:
    timeout: 10s
    send_batch_size: 1024

exporters:
  otlp:
    endpoint: "34.72.52.230:4317"
    tls:
      insecure: true
  logging:
    verbosity: detailed

service:
  pipelines:
    metrics:
      receivers: [bigip]
      processors: [batch]
      exporters: [otlp, logging]
```

### 4. Run the collector with Docker

```bash
docker run -d --name otel-collector \
  -p 8888:8888 \
  -v "$(pwd)/onprem-otel/config/otel-config.yaml:/etc/otel/config.yaml" \
  -e BIGIP_USERNAME="admin" \
  -e BIGIP_PASSWORD="your_secure_password" \
  --restart unless-stopped \
  ghcr.io/f5devcentral/application-study-tool/otel_custom_collector:v0.9.2 \
  --config=/etc/otel/config.yaml
```

### 5. Verify it's running

```bash
docker ps | grep otel-collector
```

### 6. Check logs to ensure it's working

```bash
docker logs otel-collector
```

### 7. Management Commands

**Stop the collector:**
```bash
docker stop otel-collector
```

**Remove the container:**
```bash
docker rm otel-collector
```

## GCP Infrastructure Components

The repository includes Kubernetes manifests for deploying:

- OpenTelemetry Collector in GCP (services/otel)
- Prometheus for metrics storage (services/monitoring/prometheus)
- Grafana for visualization (services/monitoring/grafana)

## Security Considerations

For production deployments:

1. Use proper TLS certificates instead of `insecure: true` and `insecure_skip_verify: true`
2. Implement proper authentication for the OpenTelemetry Collector
3. Store sensitive credentials in Kubernetes Secrets or environment variables
4. Restrict network access to your collectors using appropriate firewall rules