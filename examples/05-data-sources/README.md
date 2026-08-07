# Example 05: Data Sources

## Overview

This example introduces the concept of data sources.

Data sources allow Terraform to retrieve information about infrastructure or configuration that already exists rather than creating new resources.

In real-world environments, data sources are commonly used to:

- Read existing resource groups
- Read existing virtual networks
- Read existing DNS zones
- Read secrets from secret stores
- Read outputs from other Terraform configurations

Understanding data sources is important because most Terraform deployments interact with existing infrastructure.

---

## Files

```text
05-data-sources/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What data sources are
- How data sources differ from resources
- Why existing infrastructure is often queried
- Common data source use cases
- How retrieved values can be consumed elsewhere

---

## Resources vs Data Sources

A common point of confusion is the difference between resources and data sources.

### Resources

Resources create or manage infrastructure.

Example:

```hcl
resource "azurerm_resource_group" "platform" {
  name     = "rg-platform-dev"
  location = "Australia East"
}
```

Terraform manages the lifecycle of the resource.

---

### Data Sources

Data sources read information.

Example:

```hcl
data "azurerm_resource_group" "platform" {
  name = "rg-platform-dev"
}
```

Terraform does not create the resource.

Terraform only retrieves information about it.

---

## Common Data Source Use Cases

### Existing Networking

Read an existing network:

```hcl
data "azurerm_virtual_network" "shared" {
  name                = "vnet-shared"
  resource_group_name = "rg-network"
}
```

---

### Existing Resource Groups

```hcl
data "azurerm_resource_group" "platform" {
  name = "rg-platform-dev"
}
```

---

### Existing Secrets

```hcl
data "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-password"
  key_vault_id = azurerm_key_vault.main.id
}
```

---

### Remote State

```hcl
data "terraform_remote_state" "networking" {
  backend = "azurerm"
}
```

This allows one Terraform configuration to consume outputs from another.

---

## Why Data Sources Are Important

In enterprise environments, teams rarely build everything from scratch.

Example:

```text
Shared Network Team
          │
          ▼
Creates Network
          │
          ▼
Application Team
          │
          ▼
Reads Existing Network
```

Data sources make this integration possible.

---

## Running the Example

### Initialize

```bash
terraform init
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

---

## Example Output

```text
application_name = "customer-api"

environment = "dev"

application_details = {
  application = "customer-api"
  environment = "dev"
}
```

---

## Best Practices

### Do

- Use data sources for shared infrastructure.
- Use data sources for secrets.
- Reference existing platform resources.
- Use remote state carefully.

### Don't

- Duplicate infrastructure already managed elsewhere.
- Hardcode identifiers unnecessarily.
- Recreate shared resources when they already exist.
- Store secrets directly in code.

---

## Real-World Examples

Organizations commonly use data sources for:

```text
Shared VPCs / VNets
DNS Zones
Resource Groups
Subnets
Key Vaults
Secrets Manager
Remote State
Identity Resources
```

Reading existing infrastructure is often more common than creating new infrastructure.

---

## Key Takeaways

- Data sources retrieve information about existing infrastructure.
- Resources create or manage infrastructure.
- Data sources help Terraform integrate with existing environments.
- Data sources are commonly used for networking, secrets, shared services, and remote state.
- Understanding data sources is essential for real-world Terraform deployments.

---

## Next Example

Continue to:

```text
06-count
```

to learn how Terraform can create multiple resources using the `count` meta-argument.