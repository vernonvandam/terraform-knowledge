# Terraform Testing

## Overview

Testing is the practice of verifying that Terraform configurations, modules, and deployed infrastructure behave as expected.

While `terraform validate` confirms that configuration syntax is correct, testing provides confidence that the infrastructure produced by Terraform meets functional, operational, security, and business requirements.

Testing should be incorporated throughout the infrastructure lifecycle and not treated as a final deployment step.

---

## Why Test Terraform?

Infrastructure failures can have significant impacts, including:

- Service outages
- Security vulnerabilities
- Performance degradation
- Cost overruns
- Failed deployments

Testing reduces risk by identifying issues before infrastructure changes reach production.

Benefits include:

- Improved deployment confidence
- Earlier defect detection
- Reduced operational incidents
- Safer infrastructure changes
- Increased maintainability
- Faster delivery cycles

---

## Testing Pyramid for Terraform

Terraform testing should be performed at multiple levels.

```text
                End-to-End Tests
                      ▲
                      │
              Integration Tests
                      ▲
                      │
                Module Tests
                      ▲
                      │
             Validation & Linting
```

The lower levels should execute frequently and quickly, while higher-level tests should focus on validating real-world behaviour.

---

## Types of Terraform Testing

### Validation Testing

Validation confirms that Terraform configurations are syntactically correct and internally consistent.

Examples:

```bash
terraform fmt -check
terraform validate
```

Validation should be considered the minimum testing requirement for all Terraform repositories.

---

### Module Testing

Module testing verifies that reusable modules behave as expected.

Common checks include:

- Variable handling
- Resource creation
- Conditional logic
- Outputs
- Naming conventions
- Tagging standards

Example questions:

- Does the module create all required resources?
- Are outputs generated correctly?
- Do optional settings behave correctly?
- Are invalid inputs rejected?

---

### Integration Testing

Integration tests verify that multiple infrastructure components work together correctly after deployment.

Examples:

- A virtual machine can access a database
- Network routing functions correctly
- Security groups allow expected traffic
- DNS records resolve correctly

These tests help identify issues that cannot be detected through static analysis.

---

### End-to-End Testing

End-to-end testing validates complete business scenarios using deployed infrastructure.

Examples:

- Application deployment is accessible to users
- Authentication processes function correctly
- High availability configurations behave as expected
- Disaster recovery processes succeed

These tests provide the highest level of confidence but are typically the most expensive to execute.

---

## Testing Terraform Modules

Reusable modules should be tested independently whenever possible.

### Areas to Validate

#### Input Variables

Verify that:

- Required variables are enforced
- Defaults behave correctly
- Invalid values are rejected

Example:

```hcl
variable "environment" {
  type = string

  validation {
    condition = contains(
      ["dev", "test", "prod"],
      var.environment
    )

    error_message = "Invalid environment."
  }
}
```

#### Resource Creation

Confirm all expected resources are created when valid inputs are provided.

#### Conditional Logic

Verify optional resources are created or skipped correctly.

Example:

```hcl
count = var.enable_monitoring ? 1 : 0
```

#### Outputs

Validate that module outputs expose the required information.

---

## Automated Testing Approaches

### Local Testing

Developers should perform basic testing before committing code.

Recommended commands:

```bash
terraform fmt -check
terraform validate
terraform plan
```

---

### Pull Request Testing

Each pull request should automatically execute:

- Formatting checks
- Validation checks
- Linting checks
- Security scans
- Terraform plans

This ensures common issues are detected before code is merged.

---

### Environment Testing

After deployment, automated tests should verify:

- Resource availability
- Connectivity
- Configuration compliance
- Security requirements

Environment testing validates the actual deployed infrastructure rather than the Terraform code alone.

---

## Test Environments

Dedicated testing environments are strongly recommended.

Typical environment progression:

```text
Development
    │
    ▼
Test
    │
    ▼
Staging
    │
    ▼
Production
```

Testing should occur before promoting infrastructure changes to higher environments.

---

## Testing Considerations

### Idempotency

Terraform deployments should be repeatable.

A successful deployment should produce no unexpected changes when re-run.

Example:

```bash
terraform plan
```

Expected result:

```text
No changes.
Your infrastructure matches the configuration.
```

---

### Security Validation

Testing should include security verification.

Examples:

- Encryption enabled
- Logging configured
- Required tags applied
- Network exposure restricted
- Secure defaults enforced

---

### Cost Awareness

Testing should ensure infrastructure changes do not introduce unexpected costs.

Review:

- Resource sizing
- Scaling settings
- Storage allocations
- High-cost service selections

---

### Drift Detection

Infrastructure may change outside Terraform.

Regular testing should include drift detection to identify:

- Manual changes
- Deleted resources
- Configuration mismatches

Example:

```bash
terraform plan
```

Unexpected changes should be investigated immediately.

---

## Common Testing Challenges

### Long Deployment Times

Some environments take considerable time to provision.

Mitigation:

- Test modules independently
- Use smaller test environments
- Parallelise testing where possible

---

### Shared Environments

Multiple teams using the same environment can create unpredictable results.

Mitigation:

- Isolated testing environments
- Dedicated state files
- Automated cleanup procedures

---

### Complex Infrastructure Dependencies

Infrastructure components often depend on external systems.

Mitigation:

- Design modules with clear boundaries
- Reduce coupling where possible
- Test integrations separately

---

## Testing Best Practices

### Do

- Test early and often
- Automate testing wherever possible
- Test reusable modules independently
- Validate infrastructure after deployment
- Include security validation
- Fail fast when errors are detected
- Review deployment plans before applying

### Don't

- Rely solely on manual testing
- Skip testing for small changes
- Deploy untested modules to production
- Ignore failed test results
- Assume validation is sufficient testing

---

## Recommended Testing Workflow

```text
Developer Change
        │
        ▼
terraform fmt
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
Module Tests
        │
        ▼
Integration Tests
        │
        ▼
Deployment
        │
        ▼
Post-Deployment Verification
```

---

## Key Takeaways

- Testing is essential for reliable Infrastructure as Code.
- Validation alone is not sufficient.
- Testing should occur at multiple levels.
- Module, integration, and end-to-end testing provide increasing confidence.
- Automated testing improves consistency and reduces risk.
- Infrastructure should be verified both before and after deployment.
- Mature Terraform teams treat testing as a core engineering practice rather than an optional activity.