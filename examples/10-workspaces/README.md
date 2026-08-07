# Example 10: Workspaces

## Overview

This example demonstrates Terraform workspaces.

Workspaces allow multiple independent state files to be managed from a single Terraform configuration.

A common use case is deploying the same infrastructure to multiple environments such as:

```text
Development
Test
Production
```

Each workspace maintains its own state while sharing the same Terraform code.

---

## Files

```text
10-workspaces/
│
├── main.tf
├── outputs.tf
├── versions.tf
└── README.md
```

---

## Learning Objectives

After completing this example you should understand:

- What Terraform workspaces are
- How workspaces manage separate state
- How to access the current workspace
- How to create environment-specific behaviour
- Workspace lifecycle commands
- Benefits and limitations of workspaces

---

## What Is A Workspace?

A workspace represents an isolated state instance.

Example:

```text
Terraform Code
       │
       ├── dev State
       ├── test State
       └── prod State
```

Each workspace can manage separate infrastructure while reusing the same configuration.

---

## Default Workspace

Every Terraform configuration starts with:

```text
default
```

workspace.

Verify the current workspace:

```bash
terraform workspace show
```

Output:

```text
default
```

---

## Creating A Workspace

Create a new workspace:

```bash
terraform workspace new dev
```

Create another:

```bash
terraform workspace new test
```

Create production:

```bash
terraform workspace new prod
```

List workspaces:

```bash
terraform workspace list
```

Example:

```text
* default
  dev
  test
  prod
```

The asterisk indicates the active workspace.

---

## Switching Workspaces

Change the active workspace:

```bash
terraform workspace select dev
```

Verify:

```bash
terraform workspace show
```

Output:

```text
dev
```

Terraform now uses the state associated with that workspace.

---

## Using terraform.workspace

Terraform provides a built-in value:

```hcl
terraform.workspace
```

Example:

```hcl
resource_name = "${local.application_name}-${terraform.workspace}"
```

Workspace:

```text
dev
```

Result:

```text
customer-api-dev
```

Workspace:

```text
prod
```

Result:

```text
customer-api-prod
```

---

## Environment-Specific Configuration

Workspaces can drive configuration differences.

Example:

```hcl
instance_sizes = {
  dev  = "small"
  test = "medium"
  prod = "large"
}
```

Terraform selects a value based on:

```hcl
terraform.workspace
```

Result:

```text
dev   → small
test  → medium
prod  → large
```

This allows a single code base to support multiple environments.

---

## Running The Example

### Initialize

```bash
terraform init
```

### Create Workspaces

```bash
terraform workspace new dev

terraform workspace new test

terraform workspace new prod
```

### Select A Workspace

```bash
terraform workspace select dev
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

## Example Outputs

### Dev

```text
current_workspace = "dev"

resource_name = "customer-api-dev"

instance_size = "small"
```

---

### Test

```text
current_workspace = "test"

resource_name = "customer-api-test"

instance_size = "medium"
```

---

### Production

```text
current_workspace = "prod"

resource_name = "customer-api-prod"

instance_size = "large"
```

---

## Understanding State Separation

Each workspace maintains separate state.

Example:

```text
default
   │
   ▼
terraform.tfstate.d/default

dev
   │
   ▼
terraform.tfstate.d/dev

test
   │
   ▼
terraform.tfstate.d/test

prod
   │
   ▼
terraform.tfstate.d/prod
```

Terraform views resources in each workspace as independent.

---

## Common Use Cases

Workspaces are often used for:

```text
Development Environments
Testing Environments
Sandbox Deployments
Feature Validation
Temporary Environments
```

They can help reduce code duplication during experimentation.

---

## Limitations Of Workspaces

Workspaces are not always the best solution.

Challenges include:

```text
Limited Environment Isolation
Shared Configuration
Shared Backend
Shared Lifecycle
```

As environments become more complex, separate environment configurations are often preferred.

---

## Workspaces vs Environment Folders

### Workspaces

Structure:

```text
One Configuration
Multiple States
```

Example:

```text
dev
test
prod
```

using:

```bash
terraform workspace
```

commands.

---

### Environment Folders

Structure:

```text
environments/
├── dev
├── test
└── prod
```

Each environment has:

- Separate state
- Separate variables
- Separate pipelines

This approach is common in enterprise environments.

---

## Enterprise Guidance

Workspaces work well for:

- Learning Terraform
- Laboratories
- Small deployments
- Temporary environments

Many enterprise platforms prefer:

```text
Separate Environment Configurations
```

because they provide stronger isolation and governance.

---

## Best Practices

### Do

- Use clear workspace names.
- Verify the active workspace before deployment.
- Use workspaces for experimentation and learning.
- Include workspace names in resource naming.

### Don't

- Assume workspaces provide security boundaries.
- Use workspaces as a substitute for governance.
- Forget to verify the active workspace.
- Share production and development workflows unintentionally.

---

## Common Workspace Commands

Show current workspace:

```bash
terraform workspace show
```

List workspaces:

```bash
terraform workspace list
```

Create workspace:

```bash
terraform workspace new dev
```

Select workspace:

```bash
terraform workspace select prod
```

Delete workspace:

```bash
terraform workspace delete dev
```

---

## Key Takeaways

- Workspaces provide multiple state instances for a single Terraform configuration.
- The current workspace is available through `terraform.workspace`.
- Workspaces can drive environment-specific naming and configuration.
- Each workspace maintains independent state.
- Workspaces are useful for development, testing, and experimentation.
- Larger organizations often use separate environment configurations instead of relying solely on workspaces.
- Always verify the active workspace before running Terraform operations.

---

## Next Example

Continue to:

```text
11-import-blocks
```

to learn how Terraform can adopt and manage infrastructure that already exists outside of Terraform state.