resource "azurerm_key_vault" "kv" {
  name                            = var.keyvault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  rbac_authorization_enabled     =  true
  sku_name                        = "standard"
  public_network_access_enabled   = false
  purge_protection_enabled        = true
  soft_delete_retention_days      = 90
  tags                            = var.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}

# Only kubelet identity gets Secret User access — least privilege
resource "azurerm_role_assignment" "workload_secret_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         =  var.kubelet_principal_id
}


resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.kv_admin_principal_id
}