output "cluster_name" {
  description = "The name of the cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "get_credentials_command" {
  description = "Command to get credentials for the cluster"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region}"
}

output "kubectl_command" {
  description = "Command to configure kubectl for the cluster"
  value       = "kubectl config set-cluster ${google_container_cluster.primary.name} --server=https://${google_container_cluster.primary.endpoint} --certificate-authority=${google_container_cluster.primary.master_auth[0].cluster_ca_certificate}"
} 