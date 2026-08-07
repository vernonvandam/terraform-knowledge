# Terraform Drift

## Overview

Infrastructure drift occurs when the actual state of deployed infrastructure differs from the configuration defined in Terraform.

Drift is one of the most common operational challenges in Infrastructure as Code (IaC) environments and can lead to:

- Failed deployments
- Unexpected outages
- Security vulnerabilities
- Compliance violations
- Increased operational risk
- Unpredictable Terraform plans

As infrastructure environments grow, drift management becomes a critical operational responsibility.

---

## What Is Drift?

Terraform operates by comparing:

```text
Terraform Configuration
            │
            ▼
Terraform State
            │
            ▼
Actual Infrastructure
```

Ideally, all three remain aligned.

Drift occurs when infrastructure changes outside Terraform.

Example:

```hcl
resource "azurerm_linux_virtual_machine" "app" {
  size = "Standard_B2s"
}
```

Terraform expects:

```text
Standard_B2s
```

An administrator manually changes the VM to:

```text
Standard_D4s
```

Now:

```text
Terraform Configuration
      ≠
Actual Infrastructure
```

Infrastructure has drifted.

---

## Why Drift Matters

Drift reduces confidence in Infrastructure as Code.

When Terraform state no longer reflects reality:

- Plans become unpredictable
- Deployments become riskier
- Reviews become less accurate
- Security compliance may be impacted
- Operational troubleshooting becomes harder

Over time, unmanaged drift can undermine the benefits of Terraform entirely.

---

## Types of Drift

### Configuration Drift

The most common form of drift.

Terraform configuration:

```hcl
instance_type = "small"
```

Actual resource:

```text
Instance Type = large
```

Configuration and infrastructure no longer match.

---

### State Drift

State drift occurs when Terraform state is inaccurate.

Example:

```text
Terraform State
     │
     ▼
Storage Account Exists
```

Actual infrastructure:

```text
Storage Account Deleted
```

Terraform still believes the resource exists.

---

### Partial Drift

Only specific attributes differ.

Example:

```text
Virtual Machine
```

Matches Terraform except for:

```text
Tags
```

Terraform remains mostly accurate but still detects changes.

---

### Resource Drift

An entire resource differs from Terraform expectations.

Examples:

- Resource deleted
- Resource replaced manually
- Resource migrated outside Terraform

This often leads to major plan changes.

---

## Common Causes of Drift

### Manual Changes

The most common cause of drift.

Administrators modify infrastructure using:

- Azure Portal
- AWS Console
- Google Cloud Console
- CloudShell
- CLI tools

Example:

```text
Developer updates firewall rule manually
```

Terraform becomes unaware of the change.

---

### Emergency Fixes

Production incidents often lead to temporary changes.

Example:

```text
Open firewall immediately
```

The change resolves the incident but is never added back into Terraform.

Months later the environment has drifted significantly.

---

### Third-Party Automation

Many platforms automatically modify infrastructure.

Examples:

- Auto-scaling services
- Security tooling
- Managed Kubernetes services
- Database platforms
- Monitoring systems

Terraform detects changes it did not create.

---

### Infrastructure Managed By Multiple Tools

Example:

```text
Terraform
    +
PowerShell
    +
Cloud CLI
```

Multiple management tools increase the likelihood of drift.

Infrastructure should ideally have a single source of truth.

---

### Failed Deployments

Interrupted or failed deployments may leave infrastructure partially changed.

Example:

```text
Resource Created
Resource Updated
Deployment Failed
```

State may not accurately reflect reality.

---

### Resource Recreation

Cloud providers may replace underlying resources.

Examples:

- Managed services
- Platform upgrades
- Automated maintenance operations

Terraform may observe changes during future refresh operations.

---

## Detecting Drift

### Terraform Plan

The primary drift detection mechanism is:

```bash
terraform plan
```

Terraform compares:

```text
Configuration
        vs
State
        vs
Infrastructure
```

Example output:

```text
~ update in-place
```

Unexpected changes frequently indicate drift.

---

### Refresh-Only Plan

A safer drift review method:

```bash
terraform plan -refresh-only
```

Terraform updates its understanding of infrastructure without proposing configuration changes.

Benefits:

- Safe inspection
- No modifications
- Clear visibility into drift

---

### State Inspection

Review managed resources:

```bash
terraform state list
```

Inspect individual resources:

```bash
terraform state show RESOURCE
```

Example:

```bash
terraform state show azurerm_virtual_network.main
```

Useful when investigating state discrepancies.

---

### Infrastructure Auditing

Compare Terraform-managed resources against:

- Cloud inventories
- Resource Graph queries
- CMDB records
- Cloud governance tools

This can help identify resources that Terraform no longer manages correctly.

---

## Drift Detection Workflow

A common drift review process:

```text
Terraform Plan
        │
        ▼
Unexpected Changes?
        │
    Yes ▼ No
        │
        ▼
Investigate Resources
        │
        ▼
Determine Root Cause
        │
        ▼
Remediate Drift
```

Regular review helps prevent drift accumulation.

---

## Understanding Drift in Plans

Example:

```text
~ size = "Standard_B2s" -> "Standard_D4s"
```

Terraform has detected that reality differs from configuration.

You must determine:

1. Was the change intentional?
2. Should Terraform adopt it?
3. Should Terraform revert it?

Never apply plans without understanding drift implications.

---

## Resolving Drift

### Option 1: Revert Drift

Return infrastructure to its intended Terraform state.

Example:

```bash
terraform apply
```

Terraform restores:

```text
Standard_B2s
```

Use this approach when the manual change was unauthorised or temporary.

---

### Option 2: Accept Drift

Update Terraform configuration to reflect reality.

Example:

```hcl
size = "Standard_D4s"
```

Run:

```bash
terraform apply
```

Terraform becomes aligned again.

Suitable when the change was valid and permanent.

---

### Option 3: Import Missing Resources

If resources exist but Terraform is unaware of them:

```hcl
import {
  to = azurerm_storage_account.logs
  id = "/subscriptions/.../storageAccounts/logs"
}
```

Imports reconcile infrastructure and state.

---

### Option 4: Remove Resources From State

Sometimes Terraform should stop managing a resource.

Example:

```bash
terraform state rm RESOURCE
```

Use cautiously.

Future plans may recreate the resource.

---

## Drift Remediation Process

When drift is detected, the objective is to safely return Terraform, state, and infrastructure to alignment.

### Step 1: Identify the Drift

Run:

```bash
terraform plan
```

or

```bash
terraform plan -refresh-only
```

Review all proposed changes carefully.

Example:

```text
~ vm_size = "Standard_B2s" -> "Standard_D4s"
```

Ask:

- Was this change intentional?
- Was it approved?
- Should Terraform own this setting?
- Is the current infrastructure state correct?

Never blindly apply a plan.

---

### Step 2: Determine the Source of Truth

Once drift has been identified, determine which state is correct.

#### Option A: Terraform Is Correct

If the infrastructure was modified manually and Terraform represents the approved configuration:

```text
Terraform Configuration
        ↓
Apply
        ↓
Infrastructure Returns To Desired State
```

Run:

```bash
terraform apply
```

Terraform will restore the infrastructure to the desired configuration.

---

#### Option B: Infrastructure Is Correct

Sometimes infrastructure changes are intentional.

Examples:

- Approved production change
- Emergency outage remediation
- Capacity upgrade
- Security improvement

Update Terraform to match reality.

Before:

```hcl
sku = "Standard"
```

Actual infrastructure:

```text
Premium
```

Update configuration:

```hcl
sku = "Premium"
```

Then run:

```bash
terraform apply
```

Terraform and infrastructure become aligned again.

---

### Step 3: Handle Missing Resources

Scenario:

```text
Terraform State:
  Storage Account Exists

Reality:
  Storage Account Deleted
```

Options:

#### Recreate Resource

```bash
terraform apply
```

Terraform rebuilds the missing resource.

#### Remove Resource

If the resource is no longer required:

```hcl
# Remove configuration
```

Apply the change to remove it from Terraform management.

---

### Step 4: Handle Unmanaged Resources

Scenario:

```text
Storage Account Created Manually
```

Terraform is unaware of the resource.

Import it into management:

```hcl
import {
  to = azurerm_storage_account.logs
  id = "/subscriptions/.../storageAccounts/logs"
}
```

Apply:

```bash
terraform apply
```

The resource becomes Terraform managed.

---

### Step 5: Repair State Drift

Sometimes infrastructure is correct but state is inaccurate.

Refresh state:

```bash
terraform plan -refresh-only
```

or

```bash
terraform apply -refresh-only
```

This updates Terraform state without modifying infrastructure.

---

## Preventing Drift

The most effective drift management strategy is preventing drift from occurring.

### Make Terraform the Source of Truth

Avoid:

```text
Terraform
    +
Portal Changes
    +
CLI Scripts
```

Prefer:

```text
Terraform
      +
CI/CD
```

All infrastructure changes should originate from Terraform.

---

### Restrict Manual Changes

Limit production access wherever possible.

Example:

```text
Production Environment

Developers:
    Read Only

Operations Team:
    Terraform Deployments

Emergency Changes:
    Break-Glass Process
```

Reducing manual access significantly reduces drift.

---

### Use Branch Protection

Infrastructure changes should follow a controlled workflow.

```text
Feature Branch
       │
       ▼
Pull Request
       │
       ▼
Review
       │
       ▼
Merge
       │
       ▼
Deployment Pipeline
```

Every infrastructure change becomes auditable and traceable.

---

## Drift Prevention in CI/CD

A mature Terraform platform continuously detects and reports drift.

### Validate Every Pull Request

Example workflow:

```text
Pull Request
      │
      ▼
terraform fmt
      │
      ▼
terraform validate
      │
      ▼
tflint
      │
      ▼
terraform plan
```

This prevents invalid changes from reaching production.

---

### Scheduled Drift Detection

Run Terraform plans on a schedule.

Example:

```yaml
schedule:
  - cron: "0 2 * * *"
```

Pipeline command:

```bash
*erraform plan -detailed-exitcode
`*`

Exit codes:

```text
0 = No Cha*ges
1 = Error
2 = Drift Detected
`*`

This allows drift to be detecte* without waiting for the next depl*yment.

---

### Generate Drift Re*


## Intentional Drift

Not all drift is problematic.

Certain attributes may legitimately change outside Terraform.

Examples:

- Auto-generated tags
- Timestamps
- Monitoring metadata
- Cloud-managed settings

These changes may be tolerated.

---

## Using Ignore Changes

Terraform can ignore specific attributes.

Example:

```hcl
resource "azurerm_resource_group" "main" {

  lifecycle {

    ignore_changes = [
      tags
    ]

  }

}
```

Terraform no longer attempts to correct externally managed tags.

---

## Risks of Ignore Changes

Overusing:

```hcl
ignore_changes
```

can hide genuine issues.

Avoid:

```hcl
ignore_changes = all
```

This effectively disables Terraform management for the resource.

Ignore only specific attributes with a clear justification.

---

## Drift in CI/CD Pipelines

Many organisations detect drift automatically.

Example process:

```text
Scheduled Pipeline
        │
        ▼
terraform plan
        │
        ▼
Detect Drift
        │
        ▼
Generate Report
        │
        ▼
Notify Teams
```

This provides early visibility before deployments occur.

---

## Drift and Security

Drift can create security risks.

Examples:

### Firewall Changes

```text
Port 22 opened manually
```

Terraform configuration still assumes it is closed.

### Public Exposure

```text
Private resource changed to public
```

Security controls may be weakened without visibility.

### IAM Changes

Permissions manually expanded.

Terraform can no longer guarantee least-privilege access.

Regular drift detection improves security posture.

---

## Drift and Compliance

Many compliance frameworks require infrastructure consistency.

Examples include:

- ISO 27001
- SOC 2
- NIST
- CIS Benchmarks

Infrastructure drift can result in:

- Audit findings
- Policy violations
- Governance concerns

Terraform helps maintain compliance only when drift is actively managed.

---

## Preventing Drift

### Make Terraform the Source of Truth

All infrastructure changes should be made through Terraform.

Avoid:

```text
Terraform
    +
Manual Portal Changes
```

Prefer:

```text
Terraform Only
```

---

### Restrict Manual Access

Limit permissions to production environments.

Example:

```text
Read Access
      +
Terraform Deployment Rights
```

rather than unrestricted administrator access.

---

### Use CI/CD Pipelines

Deploy through approved pipelines.

Benefits:

- Auditability
- Consistency
- Reduced manual intervention

---

### Enable Governance Controls

Implement:

- Policy-as-Code
- Change approvals
- Access reviews
- Deployment reviews

Strong governance reduces drift opportunities.

---

### Regular Drift Reviews

Schedule recurring checks.

Examples:

```text
Daily
Weekly
Monthly
```

Depending on environment criticality.

The longer drift remains undetected, the larger the risk.

---

## Key Takeaways

- Drift occurs when infrastructure differs from Terraform configuration or state.
- The most common cause of drift is manual infrastructure modification.
- Terraform plans are the primary mechanism for identifying drift.
- Drift can impact reliability, security, compliance, and operational effectiveness.
- Every drift event should be investigated before remediation.
- Terraform or the infrastructure must be identified as the source of truth.
- Scheduled drift detection should be implemented within CI/CD pipelines.
- Infrastructure changes should flow through pull requests and deployment pipelines rather than manual updates.
- Remote state, governance controls, and policy-as-code help reduce drift.
- Mature Terraform environments aim for continuous drift detection and minimal manual production changes.