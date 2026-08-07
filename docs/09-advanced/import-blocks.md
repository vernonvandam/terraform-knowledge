# Terraform Import Blocks

## Overview

Terraform import blocks provide a declarative method for importing existing infrastructure into Terraform state.

Introduced in Terraform 1.5, import blocks allow import operations to be defined directly in Terraform configuration rather than being executed manually through CLI commands.

This represents a significant improvement in infrastructure onboarding, making import operations:

- Repeatable
- Auditable
- Version controlled
- Reviewable through pull requests
- Suitable for CI/CD workflows

Import blocks are particularly useful when adopting Terraform for existing environments that were originally created manually or through other automation tools.

---

## Why Import Existing Infrastructure?

In many organisations, infrastructure already exists before Terraform is introduced.

Examples include:

- Manually created cloud resources
- Legacy infrastructure
- Resources created through portals
- Resources deployed using scripts
- Infrastructure managed by another team

Rather than recreating these resources, Terraform can import them into state and begin managing them safely.

---

## Traditional Import Approach

Historically, imports were performed using the Terraform CLI.

Example:

```bash
terraform import aws_s3_bucket.logs company-logs
```

While functional, this approach has several challenges:

### Limitations

- Commands are not version controlled
- Imports cannot be peer reviewed
- Import history is difficult to track
- Repeatability is limited
- Documentation is often incomplete

As a result, organisations frequently struggled to reproduce imports consistently.

---

## Declarative Import Blocks

Terraform now supports import operations directly within configuration.

Example:

```hcl
import {
  to = aws_s3_bucket.logs
  id = "company-logs"
}
```

Terraform processes the import during planning and apply operations.

Benefits include:

- Stored in source control
- Visible in pull requests
- Easier collaboration
- Repeatable deployment workflows
- Better governance

---

## Import Block Structure

An import block contains two required attributes:

```hcl
import {
  to = resource.address
  id = "resource-id"
}
```

### to

Identifies the Terraform resource that will manage the imported object.

Example:

```hcl
to = aws_s3_bucket.logs
```

### id

Specifies the provider-specific resource identifier.

Example:

```hcl
id = "company-logs"
```

The required import identifier varies between resource types and providers.

---

## Basic Import Example

Existing resource:

```text
S3 Bucket
Name: company-logs
```

Terraform configuration:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}

import {
  to = aws_s3_bucket.logs
  id = "company-logs"
}
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

Terraform imports the existing bucket into state rather than creating a new one.

---

## Importing Resource Groups

Example:

```hcl
resource "azurerm_resource_group" "platform" {
  name     = "rg-platform-prod"
  location = "Australia East"
}

import {
  to = azurerm_resource_group.platform
  id = "/subscriptions/xxxxxxxx/resourceGroups/rg-platform-prod"
}
```

Terraform associates the existing resource group with the Terraform resource definition.

---

## Importing Resources into Modules

Resources within modules can also be imported.

Example:

```hcl
module "networking" {
  source = "./modules/networking"
}
```

Import block:

```hcl
import {
  to = module.networking.azurerm_virtual_network.main
  id = "/subscriptions/xxx/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-prod"
}
```

Terraform imports the resource into the module's state address.

---

## Multiple Imports

Multiple resources can be imported within the same configuration.

Example:

```hcl
import {
  to = aws_s3_bucket.logs
  id = "logs-bucket"
}

import {
  to = aws_s3_bucket.backups
  id = "backup-bucket"
}
```

Terraform processes each import individually.

---

## Import Workflow

A common import workflow consists of the following steps:

```text
Identify Existing Resource
            │
            ▼
Create Terraform Configuration
            │
            ▼
Add Import Block
            │
            ▼
Terraform Plan
            │
            ▼
Terraform Apply
            │
            ▼
Resource Added To State
```

---

## Importing at Scale

Large organisations may need to import hundreds or thousands of resources.

Common strategies include:

- Import foundational resources first
- Import by application or service
- Import by environment
- Import module-by-module
- Validate imports in lower environments first

A phased approach reduces risk and simplifies troubleshooting.

---

## Understanding Import IDs

Each provider defines its own import identifier format.

Examples:

### AWS

```hcl
id = "company-logs"
```

### Azure

```hcl
id = "/subscriptions/.../resourceGroups/rg-prod"
```

### Google Cloud

```hcl
id = "projects/project-id/global/networks/network1"
```

Always refer to provider documentation to determine the correct import identifier.

---

## Validating Imports

After importing a resource, run:

```bash
terraform plan
```

Ideally, Terraform should report:

```text
No changes.
Your infrastructure matches the configuration.
```

If Terraform proposes updates immediately after import, the configuration does not accurately describe the existing resource.

Additional configuration may be required.

---

## Common Import Challenges

### Incomplete Configuration

Imported resources must still be fully represented in Terraform code.

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

If additional bucket settings exist but are omitted from configuration, Terraform may attempt to modify the resource.

---

### Incorrect Import IDs

Example error:

```text
Cannot import non-existent remote object
```

Cause:

- Incorrect identifier
- Resource does not exist
- Insufficient permissions

Verify the identifier before attempting import.

---

### Configuration Drift

Imported resources often differ from organisational standards.

Example:

- Missing tags
- Incorrect naming
- Legacy settings

Terraform may detect drift immediately following import.

Review planned changes carefully before applying.

---

## Importing Production Resources

Production imports require additional caution.

Recommended approach:

1. Create resource configuration.
2. Add import block.
3. Execute plan.
4. Review proposed changes.
5. Confirm configuration matches reality.
6. Apply only after validation.

Never assume imported resources exactly match written Terraform configuration.

---

## Generating Configuration for Imports

Terraform can assist with generating configuration for imported resources.

Example:

```bash
terraform plan -generate-config-out=generated.tf
```

Benefits:

- Speeds up onboarding
- Reduces manual effort
- Helps discover existing settings

Generated configuration should always be reviewed and cleaned up before adoption.

---

## Import Blocks vs CLI Imports

### CLI Imports

```bash
terraform import aws_s3_bucket.logs company-logs
```

Advantages:

- Simple
- Works in older Terraform versions

Disadvantages:

- Not declarative
- Difficult to audit
- Not easily repeatable

---

### Import Blocks

```hcl
import {
  to = aws_s3_bucket.logs
  id = "company-logs"
}
```

Advantages:

- Version controlled
- Repeatable
- Reviewable
- CI/CD friendly
- Infrastructure-as-Code aligned

Disadvantages:

- Requires modern Terraform versions

---

## Enterprise Recommendations

When importing existing infrastructure:

- Use import blocks instead of CLI imports where possible.
- Store imports in source control.
- Review imports through pull requests.
- Import resources incrementally.
- Validate plans after every import.
- Ensure configuration reflects actual infrastructure.
- Remove temporary import blocks once the import process is complete and validated.

---

## Best Practices

### Do

- Use declarative import blocks.
- Import resources before modifying them.
- Review plans carefully after import.
- Validate imported configuration.
- Perform imports in non-production environments first.
- Document large-scale migration activities.

### Don't

- Import and immediately modify production resources.
- Ignore post-import drift.
- Assume generated configuration is production-ready.
- Import resources without understanding their current configuration.
- Perform bulk production imports without testing.

---

## Key Takeaways

- Import blocks provide a declarative way to import existing infrastructure into Terraform state.
- Imports are defined directly in Terraform configuration and can be version controlled.
- Import blocks improve repeatability, governance, and collaboration compared to traditional CLI imports.
- Imported resources must still be accurately represented in Terraform code.
- Always review plans after import to identify drift and configuration mismatches.
- Import blocks are a key capability for organisations adopting Terraform in existing environments.