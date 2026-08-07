# Example 04: Outputs

## Overview

This example demonstrates how to use Terraform outputs.

Outputs allow Terraform configurations to expose information that can be:

- Displayed after deployment
- Used by operators
- Consumed by other modules
- Referenced by automation pipelines
- Shared with dependent configurations

Outputs are one of the primary ways Terraform communicates information back to users.

---

## Files

```text
04-outputs/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What Terraform outputs are
- Why outputs are useful
- How to create outputs
- How to add output descriptions
- How to expose resource values
- How outputs support module design
- How to work with sensitive outputs

---

## What Are Outputs?

Outputs expose values from Terraform after resources are created.

Example:

```hcl
output "resource_name" {
  value = local.resource_name
}
```

Terraform displays outputs after a successful apply.

Example:

```text
resource_name = "customer-api-dev"
```

---

## Why Use Outputs?

Outputs help expose important information that may be needed after deployment.

Examples include:

- Resource identifiers
- Network addresses
- DNS names
- Storage account names
- Resource group names
- Application endpoints

Without outputs, users may need to manually inspect state or cloud resources to retrieve this information.

---

## Output Structure

An output consists of:

```hcl
output "<name>" {
  value = <expression>
}
```

Example:

```hcl
output "application_name" {
  value = var.application_name
}
```

---

## Output Descriptions

Descriptions provide documentation.

Example:

```hcl
output "resource_name" {

  description = "Generated resource name."

  value = local.resource_name

}
```

Descriptions are particularly important in reusable modules.

---

## Output Values

Outputs can expose:

### Variables

```hcl
output "application_name" {
  value = var.application_name
}
```

---

### Local Values

```hcl
output "resource_name" {
  value = local.resource_name
}
```

---

### Resource Attributes

```hcl
output "resource_id" {
  value = terraform_data.application.id
}
```

---

### Objects

```hcl
output "resource_details" {
  value = terraform_data.application.input
}
```

Terraform can output complex structures as well as simple strings.

---

## Applying the Configuration

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
terraform plan \
  -var="application_name=customer-api"
```

### Apply

```bash
terraform apply \
  -var="application_name=customer-api"
```

---

## Example Output

Example:

```text
application_name = "customer-api"

environment = "dev"

resource_name = "customer-api-dev"

resource_id = "..."

resource_details = {
  application = "customer-api"
  environment = "dev"
  name        =