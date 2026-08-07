# Example 11: Import Blocks

## Overview

This example demonstrates Terraform import blocks.

Import blocks allow Terraform to adopt and manage infrastructure that already exists outside Terraform state.

This is one of the most important capabilities for organizations adopting Terraform in environments where infrastructure was previously created manually or by another tool.

---

## Files

```text
11-import-blocks/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What import blocks are
- Why infrastructure imports are needed
- How import blocks work
- The import workflow
- Differences between import blocks and legacy imports
- Common import scenarios
- Import best practices

---

## Why Imports Exist

Terraform can only manage resources that exist in its state.

Consider:

```text
Existing Infrastructure
         │
         ▼
Virtual Machine
Storage Account
Database
Network
```

If Terraform did not create the infrastructure, it cannot manage it automatically.

Imports allow Terraform to adopt existing infrastructure without recreating it.

---

## Common Import Scenarios

Organizations often adopt Terraform after infrastructure already exists.

Examples:

```text
Manually Created Resources
Portal Deployments
Legacy Infrastructure
Cloud Formation Migrations
ARM Template Migrations
Bicep Migrations
```

Importing allows Terraform to begin managing these resources.

---

## Import Block Syntax

Terraform supports:

```hcl
import {
  to = RESOURCE_ADDRESS
  id = RESOURCE_ID
}
```

Example:

```hcl
import {
  to = aws_s3_bucket.logs
  id = "company-logs"
}
```

Terraform maps the existing infrastructure resource into state.

---

## Understanding The Import Block

Example:

```hcl
import {
  to = terraform_data.application
  id = "customer-api-dev"
}
```

Where:

```hcl
to
```

defines the Terraform resource address.

And:

```hcl
id
```

defines the identifier of the existing resource.

---

## How Import Blocks Work

Terraform performs:

```text
Read Configuration
        │
        ▼
Locate Existing Resource
        │
        ▼
Import Into State
        │
        ▼
Generate Plan
```

After import completes, Terraform begins managing the resource.

---

## Import Workflow

A common workflow:

### Step 1

Create Terraform configuration.

Example:

```hcl
resource "terraform_data" "application" {

}
```

---

### Step 2

Define import block.

Example:

```hcl
import {
  to = terraform_data.application
  id = "customer-api-dev"
}
```

---

### Step 3

Run plan.

```bash
terraform plan
```

Terraform validates the import.

---

### Step 4

Apply.

```bash
terraform apply
```

Terraform imports the resource into state.

---

## Running The Example

### Initialize

```bash
terraform init
```

### Validate

```bash
terraform validate
```

### View Plan

```bash
terraform plan
```

### Apply Import

```bash
terraform apply
```

---

## Example Output

```text
resource_id = "customer-api-dev"
```

```text
application_details = {
  application = "customer-api"
  environment = "dev"
}
```

---

## Real-World Example

Import an Azure Resource Group:

```hcl
resource "azurerm_resource_group" "platform" {
  name     = "rg-platform-prod"
  location = "Australia East"
}

import {
  to = azurerm_resource_group.platform
  id = "/subscriptions/<subscription-id>/resourceGroups/rg-platform-prod"
}
```

Terraform adopts the existing resource without recreating it.

---

## Legacy Import Method

Historically imports were performed using:

```bash
terraform import
```

Example:

```bash
terraform import \
  aws_s3_bucket.logs \
  company-logs
```

Challenges:

- Manual process
- Difficult to automate
- Not version controlled
- Poor auditability

---

## Import Blocks vs Terraform Import

### Terraform Import

```bash
terraform import
```

Characteristics:

- Manual
- Imperative
- Not stored in code

---

### Import Blocks

```hcl
import {

}
```

Characteristics:

- Declarative
- Version controlled
- Repeatable
- Reviewable

Import blocks are generally preferred.

---

## Importing Large Environments

Enterprise environments may contain:

```text
Hundreds
Thousands
Tens Of Thousands
```

of existing resources.

The recommended approach is:

```text
Discover Resources
      │
      ▼
Generate Configuration
      │
      ▼
Import Resources
      │
      ▼
Validate Plans
```

Gradual adoption reduces risk.

---

## After Import

Always verify:

```bash
terraform plan
```

A successful import does not guarantee the configuration exactly matches the infrastructure.

Terraform may still report:

```text
Changes Required
```

if configuration differs from reality.

---

## Best Practices

### Do

- Import before recreating existing infrastructure.
- Validate all imports carefully.
- Review plans after imports.
- Commit import blocks to source control.
- Test imports in lower environments.

### Don't

- Recreate production infrastructure unnecessarily.
- Assume imported resources exactly match configuration.
- Skip plan reviews.
- Perform large-scale imports without testing.
- Mix unrelated refactoring with import activities.

---

## Common Mistakes

### Incorrect Resource ID

Example:

```text
Cannot import non-existent remote object
```

Verify:

- Resource exists
- Subscription/account is correct
- Region is correct
- ID format is correct

---

### Configuration Mismatch

Import succeeds:

```text
✓ Resource Imported
```

But plan shows:

```text
~ Update Resource
```

Terraform configuration does not fully match the existing object.

Update configuration accordingly.

---

### Wrong Resource Address

Example:

```hcl
import {
  to = wrong.resource
}
```

Terraform cannot map the imported object correctly.

Always verify resource addresses.

---

## Key Takeaways

- Import blocks allow Terraform to adopt existing infrastructure.
- Imports enable Terraform adoption without recreating resources.
- Import blocks are declarative and version controlled.
- Every import requires both a resource definition and an import block.
- Imports update Terraform state, not infrastructure.
- Plans should always be reviewed after importing resources.
- Import blocks are the preferred modern approach compared to legacy `terraform import` commands.

---

## Next Example

Continue to:

```text
12-moved-blocks
```

to learn how Terraform can safely refactor and rename resources without recreating infrastructure.