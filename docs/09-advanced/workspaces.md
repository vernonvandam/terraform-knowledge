# Terraform Workspaces

## Overview

Terraform workspaces allow multiple state instances to be managed from a single Terraform configuration.

Each workspace maintains its own Terraform state, enabling the same infrastructure code to be deployed multiple times with different state data.

Common use cases include:

- Development environments
- Testing environments
- Staging environments
- Sandbox deployments
- Feature testing

Workspaces provide state isolation, not configuration isolation.

---

## Understanding Terraform State

Terraform tracks infrastructure using a state file.

Without workspaces:

```text
terraform.tfstate
```

With workspaces:

```text
default
development
test
staging
production
```

Each workspace maintains its own independent state.

For example:

```text
workspace: development
  └── development infrastructure

workspace: test
  └── test infrastructure

workspace: production
  └── production infrastructure
```

Although the Terraform code remains the same, each workspace tracks separate resources.

---

## Default Workspace

Every Terraform configuration starts with a workspace named:

```text
default
```

View the current workspace:

```bash
terraform workspace show
```

Example output:

```text
default
```

If no additional workspaces are created, Terraform uses the default workspace.

---

## Creating Workspaces

Create a new workspace:

```bash
terraform workspace new development
```

Example:

```bash
terraform workspace new test
terraform workspace new production
```

List all workspaces:

```bash
terraform workspace list
```

Example output:

```text
* development
  test
  production
```

The asterisk indicates the active workspace.

---

## Switching Workspaces

To change workspaces:

```bash
terraform workspace select production
```

Verify the active workspace:

```bash
terraform workspace show
```

Output:

```text
production
```

All subsequent Terraform operations will use the selected workspace's state.

---

## Deleting Workspaces

Delete a workspace:

```bash
terraform workspace delete development
```

Terraform prevents deletion of the currently selected workspace.

Switch first:

```bash
terraform workspace select default
terraform workspace delete development
```

---

## Workspace State Storage

When using local state, Terraform stores workspace state separately.

Example:

```text
terraform.tfstate.d/
│
├── development/
│   └── terraform.tfstate
│
├── test/
│   └── terraform.tfstate
│
└── production/
    └── terraform.tfstate
```

Each workspace maintains its own state file.

---

## Accessing the Current Workspace

Terraform exposes the workspace name through:

```hcl
terraform.workspace
```

Example:

```hcl
resource "aws_s3_bucket" "logs" {

  bucket = "logs-${terraform.workspace}"

}
```

Results:

```text
development -> logs-development
test        -> logs-test
production  -> logs-production
```

This allows resources to be environment aware.

---

## Using Workspaces for Environment Separation

A common pattern is environment-specific naming.

Example:

```hcl
locals {
  environment = terraform.workspace
}
```

Resource:

```hcl
resource "aws_vpc" "main" {

  tags = {
    Environment = local.environment
  }

}
```

Result:

```text
development
test
production
```

Each deployment is automatically tagged according to its workspace.

---

## Workspace-Specific Variables

Variables can be derived from workspace names.

Example:

```hcl
locals {

  instance_sizes = {
    development = "small"
    test        = "medium"
    production  = "large"
  }

}
```

Resource:

```hcl
instance_type = local.instance_sizes[terraform.workspace]
```

Result:

```text
development → small
test        → medium
production  → large
```

This allows infrastructure sizing to vary by environment.

---

## Workspace-Aware Configuration

Example:

```hcl
locals {

  environment_config = {

    development = {
      instance_count = 1
    }

    production = {
      instance_count = 3
    }

  }

}
```

Usage:

```hcl
count = local.environment_config[
  terraform.workspace
].instance_count
```

This pattern is useful for lightweight environment differences.

---

## Remote Backend Considerations

Many remote backends support workspaces.

Examples:

- Terraform Cloud
- Azure Storage
- Amazon S3
- Google Cloud Storage
- HCP Terraform

Remote state remains isolated per workspace while sharing the same backend configuration.

---

## Advantages of Workspaces

### Simple Environment Separation

Deploy multiple environments from the same codebase.

### State Isolation

Each environment maintains independent state.

### Reduced Code Duplication

One configuration can support multiple deployments.

### Easy Testing

Developers can create temporary workspaces for validation and experimentation.

Example:

```bash
terraform workspace new feature-123
```

Deploy:

```bash
terraform apply
```

Remove when finished:

```bash
terraform workspace delete feature-123
```

---

## Limitations of Workspaces

### Not Complete Environment Isolation

Workspaces separate state but do not separate configuration.

All environments use the same Terraform code.

### Growing Complexity

As environments diverge, workspace-based configurations become harder to manage.

Example:

```hcl
terraform.workspace == "production"
```

A small number of conditions is manageable.

Large numbers of conditional statements quickly become difficult to maintain.

### Shared Backend Configuration

Backend settings cannot vary by workspace.

Separate backends often require separate root modules.

---

## When to Use Workspaces

Workspaces work well when:

- Infrastructure is nearly identical
- Differences are small
- Temporary environments are required
- Development and testing environments are needed
- Teams want lightweight state separation

Examples:

- Personal developer environments
- Feature testing
- Integration testing
- Sandbox deployments

---

## When Not to Use Workspaces

Avoid workspaces when:

- Production environments differ significantly
- Separate access controls are required
- Different providers are used
- Different backend configurations are required
- Independent deployment lifecycles exist

In these scenarios, separate root modules or environment folders are typically preferred.

Example:

```text
environments/
│
├── dev/
├── test/
├── stage/
└── prod/
```

This approach provides stronger separation and clearer governance.

---

## Workspaces vs Environment Directories

### Workspaces

```text
Single Code Base
      │
      ├── development
      ├── test
      └── production
```

Pros:

- Less duplication
- Quick setup
- Easy testing

Cons:

- Limited flexibility
- Shared configuration
- Can become complex at scale

---

### Environment Directories

```text
environments/
├── dev
├── test
└── prod
```

Pros:

- Strong separation
- Independent configuration
- Easier governance

Cons:

- More code management
- Additional maintenance

---

## Enterprise Recommendations

For enterprise production environments:

- Use separate state files.
- Use remote backends.
- Implement state locking.
- Restrict access to production state.
- Avoid excessive workspace-specific logic.
- Prefer environment directories when environments diverge significantly.
- Use workspaces primarily for development, testing, and temporary environments.

---

## Common Commands

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
terraform workspace new development
```

Select workspace:

```bash
terraform workspace select production
```

Delete workspace:

```bash
terraform workspace delete development
```

---

## Best Practices

### Do

- Use meaningful workspace names.
- Use remote state backends.
- Keep environment differences minimal.
- Tag resources with workspace names.
- Document workspace usage.

### Don't

- Use workspaces as a security boundary.
- Create excessive workspace-specific logic.
- Treat workspaces as completely isolated environments.
- Store production and non-production resources in the same state unintentionally.
- Use workspaces when separate configurations are more appropriate.

---

## Key Takeaways

- Workspaces allow multiple state instances to be managed from a single Terraform configuration.
- Each workspace maintains its own isolated state.
- Workspaces are best suited to environments that share the same infrastructure design.
- The current workspace is accessible through `terraform.workspace`.
- Workspaces simplify temporary, development, and testing deployments.
- Workspaces do not replace proper environment isolation or governance controls.
- Enterprise Terraform implementations often use workspaces for non-production scenarios and separate configurations for production environments.