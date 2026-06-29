resource "random_id" "suffix" {
  byte_length = 3
}

resource "azurerm_container_registry" "this" {
  name                = "acr${replace(var.project_name, "-", "")}${random_id.suffix.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}
