#!/bin/bash

# Exit on error
set -e

# Create monitoring namespace if it doesn't exist
echo "Creating monitoring namespace..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Add Helm repositories
echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy Prometheus
echo "Deploying Prometheus..."
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --values monitoring/prometheus/values.yaml

# Deploy Grafana
echo "Deploying Grafana..."
helm upgrade --install grafana grafana/grafana \
  --namespace monitoring \
  --values monitoring/grafana/values.yaml

echo "Deployment complete!"
echo "Waiting for services to get external IPs..."
echo "You can get the IPs with:"
echo "kubectl get svc -n monitoring"
echo "Default Grafana credentials: admin/admin" 