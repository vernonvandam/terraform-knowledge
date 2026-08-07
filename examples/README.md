# Terraform Examples

This directory contains practical Terraform examples that demonstrate concepts discussed throughout the documentation.

The examples are intentionally simple and designed to illustrate Terraform language features, patterns, and workflows rather than cloud-provider-specific implementations.

---

## Available Examples

| Example | Description |
|----------|-------------|
| 01-basic-resource | Basic Terraform resource definition |
| 02-variables | Input variables and parameterization |
| 03-locals | Local value usage |
| 04-outputs | Output value examples |
| 05-data-sources | Querying existing infrastructure |
| 06-count | Creating multiple resources using count |
| 07-for-each | Iterating resources with for_each |
| 08-dynamic-blocks | Dynamic block generation |
| 09-modules | Consuming reusable modules |
| 10-workspaces | Working with workspaces |
| 11-import-blocks | Declarative imports |
| 12-moved-blocks | Refactoring resources |
| 13-check-blocks | Runtime assertions |
| 14-lifecycle | Lifecycle meta-arguments |

---

## Prerequisites

Examples assume:

- Terraform installed
- Familiarity with Terraform fundamentals
- Completion of the documentation sections under `docs/`

---

## Recommended Learning Path

```text
01-basic-resource
       │
       ▼
02-variables
       │
       ▼
03-locals
       │
       ▼
04-outputs
       │
       ▼
05-data-sources
       │
       ▼
06-count
       │
       ▼
07-for-each
       │
       ▼
08-dynamic-blocks
       │
       ▼
09-modules
       │
       ▼
10-workspaces
       │
       ▼
11-import-blocks
       │
       ▼
12-moved-blocks
       │
       ▼
13-check-blocks
       │
       ▼
14-lifecycle
```

---

## Example Standards

Each example should:

- Be self-contained
- Focus on a single Terraform concept
- Include explanatory comments
- Include a README
- Demonstrate current Terraform best practices
- Be runnable with minimal modification

---

## Important Notes

Examples are provided for educational purposes and may require adaptation for production environments.

Production deployments should additionally incorporate:

- Remote state
- State locking
- CI/CD automation
- Security scanning
- Governance controls
- Enterprise naming standards