# Terraform Debugging

## Overview

Debugging Terraform involves identifying, analysing, and resolving issues that occur during:

- Initialization
- Validation
- Planning
- Applying
- Destroying
- State operations

Effective debugging requires understanding how Terraform processes configuration, interacts with providers, manages state, and handles dependencies.

A structured debugging approach can significantly reduce the time required to identify and resolve infrastructure issues.

---

## Common Debugging Workflow

When Terraform encounters an issue, follow a consistent troubleshooting process.

```text
Identify Error
      │
      ▼
Review Error Message
      │
      ▼
Validate Configuration
      │
      ▼
Inspect State
      │
      ▼
Review Dependencies
      │
      ▼
Enable Debug Logging
      │
      ▼
Investigate Provider Responses
      │
      ▼
Implement Fix
```

Avoid making changes until the root cause is understood.

---

## Reading Error Messages

Terraform error messages are often highly informative.

Example:

```text
Reference to undeclared resource
```

This indicates Terraform cannot locate a referenced resource.

Common causes include:

- Typographical errors
- Incorrect module references
- Deleted resources
- Incorrect output names

Always start by carefully reading the complete error message.

---

## Validating Configuration

Before investigating more complex scenarios, ensure the configuration is valid.

Format code:

```bash
terraform fmt -recursive
```

Validate syntax:

```bash
terraform validate
```

Many issues are discovered during this stage.

---

## Reviewing the Execution Plan

The execution plan provides insight into Terraform's intended actions.

Generate a plan:

```bash
terraform plan
```

Review:

- Resource creation
- Resource updates
- Resource destruction
- Dependency changes

Unexpected plan output often reveals the root cause of issues.

---

## Using Terraform Console

Terraform Console allows expressions to be evaluated interactively.

Start console:

```bash
terraform console
```

Example:

```hcl
> var.environment
```

Output:

```text
production
```

Evaluate expressions:

```hcl
> length(var.subnets)
```

Output:

```text
3
```

Terraform Console is particularly useful when debugging variables, locals, outputs, and expressions.

---

## Debugging Variables

Variables are a common source of deployment issues.

Inspect variable values:

```hcl
output "environment" {
  value = var.environment
}
```

Or use:

```bash
terraform console
```

Example:

```hcl
> var.location
```

Verify:

- Correct value
- Correct data type
- Variable file loaded
- Environment variables supplied

---

## Debugging Local Values

Locals can become complex in larger configurations.

Example:

```hcl
locals {
  environment_name = "${var.project}-${var.environment}"
}
```

Inspect:

```hcl
> local.environment_name
```

Output:

```text
platform-prod
```

Testing expressions interactively can quickly identify logic problems.

---

## Debugging Outputs

Outputs help verify what Terraform is producing.

Example:

```hcl
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}
```

Display outputs:

```bash
terraform output
```

Inspect a specific output:

```bash
terraform output vnet_id
```

Outputs are valuable when validating resource relationships.

---

## Inspecting Terraform State

Terraform state is often involved in troubleshooting.

List resources:

```bash
terraform state list
```

Example:

```text
aws_vpc.main
aws_subnet.app
aws_instance.web
```

Inspect a resource:

```bash
terraform state show aws_instance.web
```

This reveals the actual state data Terraform is managing.

---

## Refreshing State

Terraform state may become outdated.

Refresh state:

```bash
terraform refresh
```

Or:

```bash
terraform plan -refresh-only
```

This updates Terraform's understanding of the current infrastructure.

---

## Investigating Resource Dependencies

Unexpected resource behaviour is often caused by dependency issues.

Generate the dependency graph:

```bash
terraform graph
```

Complex graphs can be rendered visually:

```bash
terraform graph | dot -Tpng > graph.png
```

Review relationships between resources and modules.

---

## Enabling Debug Logging

Terraform provides detailed logging.

Enable debugging:

### Linux/macOS

```bash
export TF_LOG=DEBUG
```

### Windows PowerShell

```powershell
$env:TF_LOG="DEBUG"
```

Run Terraform:

```bash
terraform plan
```

Terraform will display additional diagnostic information.

---

## Logging Levels

Available logging levels include:

```text
TRACE
DEBUG
INFO
WARN
ERROR
```

Most troubleshooting scenarios use:

```text
DEBUG
```

For deep provider analysis:

```text
TRACE
```

---

## Writing Logs to a File

Large logs should be redirected to a file.

Linux/macOS:

```bash
export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log
```

Windows PowerShell:

```powershell
$env:TF_LOG="TRACE"
$env:TF_LOG_PATH="terraform.log"
```

Terraform writes detailed information for later analysis.

---

## Debugging Provider Issues

Provider errors are common.

Example:

```text
Error: AuthorizationFailed
```

Potential causes:

- Invalid credentials
- Expired tokens
- Missing permissions
- Subscription mismatch
- Account restrictions

Verify:

- Provider configuration
- Authentication method
- Service account permissions
- Subscription or account context

---

## Debugging Authentication Issues

Common symptoms:

```text
Authentication failed
```

Check:

- Environment variables
- Service principals
- IAM roles
- Access tokens
- Managed identities

Confirm credentials independently before investigating Terraform itself.

---

## Debugging Data Sources

Example:

```hcl
data "aws_vpc" "existing" {
  id = var.vpc_id
}
```

Common failures:

- Resource not found
- Permissions issues
- Incorrect IDs
- Region mismatch

Evaluate data source values using Terraform Console where possible.

---

## Debugging Modules

Module issues often result from:

- Missing variables
- Incorrect outputs
- Invalid source paths
- Version mismatches

Verify:

```hcl
module "networking" {
  source = "./modules/networking"
}
```

Check:

```bash
terraform init
```

to confirm module loading succeeds.

---

## Common Debugging Scenarios

### Resource Not Found

Error:

```text
Resource not found
```

Possible causes:

- Resource deleted manually
- Incorrect identifier
- Wrong subscription or account
- Region mismatch

---

### Invalid Index

Error:

```text
Invalid index
```

Example:

```hcl
var.subnets[3]
```

when only two items exist.

Verify collection lengths before accessing elements.

---

### Unsupported Attribute

Error:

```text
Unsupported attribute
```

Cause:

Terraform references an attribute that does not exist.

Example:

```hcl
aws_instance.web.invalid_attribute
```

Review provider documentation to confirm available attributes.

---

### Dependency Cycle

Error:

```text
Cycle detected
```

Cause:

Circular dependency.

Example:

```text
Resource A
     ▲
     │
     ▼
Resource B
```

Refactor the dependency chain to break the cycle.

---

## Debugging CI/CD Pipelines

When Terraform succeeds locally but fails in CI/CD:

Verify:

- Terraform version
- Provider versions
- Environment variables
- Service account permissions
- Backend access
- State locking

Environment differences are a common source of pipeline failures.

---

## Using a Minimal Reproduction

For difficult issues:

1. Create a separate test configuration.
2. Remove unrelated resources.
3. Reduce the problem to its simplest form.
4. Re-test.

Smaller configurations are easier to troubleshoot than large production deployments.

---

## Best Practices

### Do

- Read the complete error message.
- Validate configurations early.
- Use Terraform Console frequently.
- Review execution plans carefully.
- Enable logging when necessary.
- Investigate state before modifying infrastructure.
- Reproduce issues in lower environments.

### Don't

- Ignore warning messages.
- Modify state without understanding the impact.
- Assume provider errors are Terraform bugs.
- Implement fixes before identifying the root cause.
- Disable safety mechanisms during troubleshooting.

---

## Key Takeaways

- Effective debugging begins with understanding the error message.
- Terraform Console is a powerful tool for evaluating expressions and variables.
- State inspection often reveals the cause of deployment issues.
- Debug logging provides detailed visibility into Terraform and provider operations.
- Dependency and module issues are common causes of unexpected behaviour.
- A systematic troubleshooting process leads to faster and safer issue resolution.
- Successful Terraform teams treat debugging as an engineering discipline rather than a trial-and-error activity.