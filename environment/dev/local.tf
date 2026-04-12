locals {
  aks_dns_zone_name = "privatelink.${lower(replace(var.location, " ", ""))}.azmk8s.io"

  keyvault_name = substr(
    lower("kv-${var.environment}-${module.random.random_pet_name}"),
    0,
    24
  )

  acr_name = substr(
    replace(lower("acr${var.environment}${module.random.random_pet_name}"), "-", ""),
    0,
    50
  )

  tags = {
    environment = "dev"
    project     = "private-aks"
    managed_by  = "terraform"
  }
}
