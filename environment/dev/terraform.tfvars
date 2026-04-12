# IMPORTANT: Do NOT commit subscription_id or any secrets to git.
# Pass via: export TF_VAR_subscription_id="your-id"
# or via CI/CD pipeline secret variable.

resource_group_name    = "dev-rg"
location               = "central india"
suffix                 = "dev"
vnet_name              = "dev-vnet"
aks_system_subnet_name = "snet-aks-system"
aks_user_subnet_name   = "snet-aks-user"
private_subnet_name    = "snet-private-endpoint"
subscription_id        = "your-subscription-id"

vnet_address_space       = ["10.0.0.0/16"]
aks_system_subnet_prefix = ["10.0.1.0/24"]
aks_user_subnet_prefix   = ["10.0.2.0/24"]
private_subnet_prefix    = ["10.0.3.0/27"]

kubernetes_version        = "1.32"
aks_admin_group_object_id = "your-aks-admin-group-object-id"

tags = {
  environment = "dev"
  project     = "private-aks"
  managed_by  = "terraform"
}
