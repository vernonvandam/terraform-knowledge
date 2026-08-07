# Terraform Standards

This document defines the preferred Terraform engineering standards for this repository and projects derived from it.

## Principles

1. Prefer simple, readable Terraform.
2. Use reusable modules where they provide genuine value.
3. Pin Terraform and provider versions.
4. Treat state as critical infrastructure data.
5. Never hard-code secrets.
6. Prefer declarative Terraform resources over provisioners.
7. Use `for_each` when resources have stable logical identities.
8. Use meaningful variable, local, resource, and output names.
9. Keep provider-specific implementation details out of general-purpose knowledge.
10. Document non-obvious design decisions.

## Standard Decision Pattern

When Terraform offers multiple valid approaches:

1. Explain what Terraform supports.
2. Identify the generally recommended approach.
3. Define the repository/project standard.
4. Document exceptions and trade-offs.
