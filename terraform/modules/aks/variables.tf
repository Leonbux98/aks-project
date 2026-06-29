variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aks_subnet_id" {
  type = string
}

variable "node_vm_size" {
  type = string
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}

variable "kubernetes_version" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
