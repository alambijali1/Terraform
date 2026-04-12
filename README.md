# Private AKS Infrastructure — Terraform

Through Terraform created a **private AKS cluster** on Azure with ACR, Key Vault, and full private networking using reusable modules.

---

## What Gets Created

| Resource | Name Pattern | Notes |
|---|---|---|
| Resource Group | `dev-rg` | All resources live here |
| Virtual Network | `dev-vnet` | `10.0.0.0/16` |
| Subnets (3) | `snet-aks-system`, `snet-aks-user`, `snet-private-endpoint` | Separate subnets per purpose |
| AKS Cluster | `aks-dev` | Private cluster, no public FQDN |
| Container Registry | `acr<random>` | Premium SKU, no public access |
| Key Vault | `kv-dev-<random>` | RBAC auth, purge protection on |
| Private Endpoints | `pe-acr-dev`, `pe-kv-dev` | ACR and KV are privately accessible only |
| Private DNS Zones | AKS + ACR + KV zones | Linked to VNet |
| Managed Identities | AKS control plane + Kubelet | User-assigned identities |

---

## Terraform Structure

```

├── environment/
│   └── dev/
│       ├── main.tf          # Wires all modules together
│       ├── variable.tf      # Input variable definitions
│       ├── terraform.tfvars # Actual values 
│       ├── local.tf         # Computed locals (names, DNS zone)
│       ├── data.tf          # Data lookups (VNet, subnets, caller identity)
│       └── provider.tf      # azurerm + random providers + backend block + remote state management
└── modules/
    ├── azurerm_resource_group/
    ├── azurerm_virtual_network/
    ├── azurerm_subnet/
    ├── azurerm_identity/
    ├── azurerm_acr/
    ├── azurerm_key_vault/
    ├── azurerm_kubernetes_cluster/
    ├── azurerm_private_dns/
    ├── azurerm_private_endpoint/
    └── azurerm_random/
```

---

## AKS Cluster Details

- **Private cluster** — no public API server endpoint
- **Node pools**: system pool (`Standard_D4ds_v5`, 1–5 nodes) + user pool (1–10 nodes)
- **Networking**: Azure CNI + Calico network policy
- **Auth**: AAD RBAC only — local accounts disabled
- **Key Vault Secrets Provider**: enabled with 5-minute rotation interval
- **Autoscaling**: enabled on both node pools

---

## Prerequisites

- Azure CLI logged in (`az login`)
- Terraform >= 1.x
- `azurerm` provider `~> 4.67.0`
- An Azure AD group for AKS admins (its Object ID goes in `tfvars`)

---

## Usage

```bash
cd environment/dev

# 1. Set subscription ID as env var (do NOT put secrets in tfvars in git)
export TF_VAR_subscription_id="your-subscription-id"

# 2. Init
terraform init

# 3. Plan
terraform plan

# 4. Apply
terraform apply
```

---

## Key Variables

| Variable | Description | Example |
|---|---|---|
| `subscription_id` | Azure Subscription ID (**use env var**) | via `TF_VAR_subscription_id` |
| `resource_group_name` | Resource group name | `dev-rg` |
| `location` | Azure region | `central india` |
| `suffix` | Short suffix appended to resource names | `dev` |
| `kubernetes_version` | AKS Kubernetes version | `1.32` |
| `aks_admin_group_object_id` | AAD group granted Cluster Admin | GUID |
| `vnet_address_space` | VNet CIDR | `10.0.0.0/16` |

---

## Security Notes

- **Never commit `subscription_id`** to git — pass it via `TF_VAR_subscription_id` or CI/CD secret.
- ACR and Key Vault have `public_network_access_enabled = false` — accessible only via private endpoints.
- Key Vault has `purge_protection_enabled = true` and 90-day soft delete.
- ACR and Key Vault have `prevent_destroy = true` lifecycle protection.
- Kubelet identity gets minimum required roles: `AcrPull` on ACR and `Key Vault Secrets User` on Key Vault.

---

## Remote State

A backend config is in `provider.tf`.

```hcl
backend "azurerm" {
  resource_group_name  = "your-rg"
  storage_account_name = "stgdemosatfstate"
  container_name       = "tfstate"
  key                  = "dev.terraform.tfstate"
}
```