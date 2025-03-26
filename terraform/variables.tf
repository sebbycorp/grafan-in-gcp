variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default     = "project-grafana-01-454821"
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "grafana-gke-cluster"
}

variable "gke_num_nodes" {
  description = "Number of GKE nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "The machine type to use for the nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node"
  type        = number
  default     = 50
} 