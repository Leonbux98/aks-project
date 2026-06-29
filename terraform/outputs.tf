output "resource_group_name" {
  description = "Name of the main resource group"
  value       = module.resource_group.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.login_server
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}
