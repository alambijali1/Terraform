resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.suffix}"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Premium"

  private_cluster_enabled             = true
  private_dns_zone_id                 = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = false

  local_account_disabled            = true
  role_based_access_control_enabled = true
  run_command_enabled               = false

  default_node_pool {
    name                         = "system"
    vm_size                      = "Standard_D4ds_v5"
    vnet_subnet_id               = var.aks_system_subnet_id
    only_critical_addons_enabled = true
    os_disk_type                 = "Managed"
    min_count                    = 1
    max_count                    = 5
    auto_scaling_enabled         = true
    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.aks_identity_id]
  }

  kubelet_identity {
    client_id                 = var.kubelet_client_id
    object_id                 = var.kubelet_object_id
    user_assigned_identity_id = var.kubelet_identity_id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = [var.aks_admin_group_object_id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D4ds_v5"
  vnet_subnet_id        = var.aks_user_subnet_id
  min_count             = 1
  max_count             = 10
  auto_scaling_enabled  = true
  os_disk_type          = "Managed" 
  mode                  = "User"
  upgrade_settings {
    max_surge = "33%"
  }
  tags = var.tags
}

# AKS identity → Network Contributor on subnet (required for Azure CNI)
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.aks_system_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_principal_id
}

resource "azurerm_role_assignment" "aks_network_user" {
  scope                = var.aks_user_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_principal_id
}
# AKS control plane identity → Managed Identity Operator on kubelet identity (required)
resource "azurerm_role_assignment" "aks_mid_operator" {
  scope                = var.kubelet_identity_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_principal_id
}

# Cluster admin group
resource "azurerm_role_assignment" "cluster_admin" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.aks_admin_group_object_id
}

resource "azurerm_role_assignment" "aks_dns" {
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = var.aks_principal_id
}
