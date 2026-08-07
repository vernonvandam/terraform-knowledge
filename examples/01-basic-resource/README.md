# Example 01: Basic Resource

## Overview

This example demonstrates the simplest Terraform configuration possible using the built-in `terraform_data` resource.

The purpose of this example is to introduce the basic Terraform resource structure without requiring any cloud provider credentials.

## Files

```text
01-basic-resource/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

## Resource Definition

Terraform resources follow this general structure:

```hcl
resource "<TYPE>" "<NAME>" {

}
```

Example:

```hcl
resource "terraform_data" "example" {

}
```

Where:

- `terraform_data` is the resource type
- `example` is the resource name

## Example Configuration

```hcl
resource "terraform_data" "example" {
  input = {
    name        = "example-resource"
    environment = "dev"
  }
}
```

## Commands

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

### Apply

```bash
terraform apply
```

### Destroy

```bash
terraform destroy
```

## Expected Output

After applying:

```bash
terraform output
```

Example:

```text
resource_id = "..."
resource_input = {
  environment = "dev"
  name = "example-resource"
}
```

## Learning Objectives

After completing this example you should understand:

- What a Terraform resource is
- Resource type vs resource name
- Basic Terraform file structure
- Terraform lifecycle commands
- Terraform outputs
- How Terraform stores resource state

## Next Example

Continue to:

```text
02-variables
```

to learn how to parameterize Terraform configurations using input variables.