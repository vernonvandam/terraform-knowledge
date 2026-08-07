# Terraform Dependency Graph

## Overview

One of Terraform's most powerful features is its ability to automatically understand relationships between infrastructure resources and determine the correct order of operations.

Terraform builds a dependency graph from your configuration and uses that graph to:

- Determine resource creation order
- Determine resource destruction order
- Enable parallel execution
- Detect dependency cycles
- Optimise deployment performance
- Ensure infrastructure consistency

Most Terraform users benefit from the dependency graph without explicitly interacting with it, but understanding how it works is essential when managing large or complex environments.

---

## What Is a Dependency Graph?

A dependency graph is a directed graph that represents relationships between Terraform resources.

Example:

```text
Virtual Network
       │
       ▼
Subnet
       │
       ▼
Virtual Machine
```

Terraform understands that:

1. The virtual network must exist first.
2. The subnet depends on the virtual network.
3. The virtual machine depends on the subnet.

Terraform automatically works out this deployment order.

---

## Why Dependency Management Matters

Infrastructure resources rarely exist in isolation.

Common dependencies include:

- Virtual machines requiring networks
- Databases requiring subnets
- Applications requiring storage
- Load balancers requiring backend instances
- DNS records requiring public IP addresses

Deploying resources in the wrong order could result in:

- Deployment failures
- Configuration errors
- Service interruptions
- Incomplete infrastructure

Terraform's dependency graph prevents these issues.

---

## Graph Construction Process

When Terraform runs, it performs the following steps:

```text
Read Configuration
         │
         ▼
Identify Resources
         │
         ▼
Discover Dependencies
         │
         ▼
Build Dependency Graph
         │
         ▼
Generate Execution Plan
         │
         ▼
Execute Resources
```

The graph is rebuilt every time Terraform creates a plan.

---

## Implicit Dependencies

Terraform automatically identifies most dependencies through resource references.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "app" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"
}
```

Terraform detects:

```text
aws_vpc.main
     │
     ▼
aws_subnet.app
```

Because the subnet references the VPC ID, Terraform automatically knows the creation order.

No additional configuration is required.

---

## Resource References Create Dependencies

Any resource attribute reference creates a dependency.

Example:

```hcl
resource "aws_instance" "web" {

  subnet_id = aws_subnet.app.id

}
```

Terraform graph:

```text
VPC
 │
 ▼
Subnet
 │
 ▼
Instance
```

This behaviour forms the foundation of most Terraform dependency management.

---

## Explicit Dependencies

Occasionally Terraform cannot detect a dependency automatically.

In such situations, explicit dependencies can be defined using:

```hcl
depends_on
```

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_security_group.web
  ]

}
```

Terraform now guarantees that the security group is processed before the instance.

---

## When to Use depends_on

Use explicit dependencies only when Terraform cannot infer them automatically.

Common examples include:

- External systems
- Side effects
- Management resources
- Policy resources
- Monitoring resources
- Provisioners

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_cloudwatch_log_group.logs
  ]

}
```

Although no attribute reference exists, the dependency may still be required operationally.

---

## Avoid Overusing depends_on

Terraform already handles most dependency relationships automatically.

Avoid:

```hcl
resource "aws_subnet" "app" {

  depends_on = [
    aws_vpc.main
  ]

}
```

when:

```hcl
vpc_id = aws_vpc.main.id
```

already exists.

Redundant dependencies create unnecessary complexity and reduce maintainability.

---

## Graph During Resource Creation

Terraform processes resources according to dependency order.

Example:

```text
VPC
 │
 ├──────────┐
 ▼          ▼
Subnet A  Subnet B
 │          │
 ▼          ▼
VM A      VM B
```

Terraform can execute independent resources simultaneously.

Possible execution sequence:

1. Create VPC
2. Create both subnets in parallel
3. Create both virtual machines in parallel

This parallelism improves deployment speed.

---

## Graph During Resource Destruction

Dependencies are reversed during destruction.

Creation:

```text
VPC
 │
 ▼
Subnet
 │
 ▼
Virtual Machine
```

Destruction:

```text
Virtual Machine
 │
 ▼
Subnet
 │
 ▼
VPC
```

Terraform prevents resources from being destroyed while dependency relationships still exist.

---

## Parallel Execution

One of Terraform's major advantages is parallel processing.

Example:

```text
Storage Account
Database
Virtual Network
```

No dependencies exist between these resources.

Terraform may create them simultaneously.

Benefits:

- Faster deployments
- Reduced execution time
- Better scalability

Terraform automatically determines safe levels of parallelism.

---

## Viewing the Dependency Graph

Terraform can generate a visual representation of the graph.

Command:

```bash
terraform graph
```

Example output:

```text
digraph {
  aws_vpc.main
  aws_subnet.app
  aws_instance.web
}
```

For larger environments, the output can be rendered into a graphical diagram.

Example:

```bash
terraform graph | dot -Tpng > graph.png
```

This produces a visual dependency map.

---

## Example Dependency Graph

Configuration:

```hcl
resource "aws_vpc" "main" {}

resource "aws_subnet" "app" {
  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "web" {
  subnet_id = aws_subnet.app.id
}
```

Dependency graph:

```text
aws_vpc.main
       │
       ▼
aws_subnet.app
       │
       ▼
aws_instance.web
```

Terraform automatically determines the execution order.

---

## Module Dependencies

Dependencies can also exist between modules.

Example:

```hcl
module "network" {
  source = "./modules/network"
}

module "compute" {
  source = "./modules/compute"

  subnet_id = module.network.subnet_id
}
```

Terraform graph:

```text
network module
       │
       ▼
compute module
```

Modules participate in the dependency graph in the same way as resources.

---

## Explicit Module Dependencies

Example:

```hcl
module "compute" {

  source = "./modules/compute"

  depends_on = [
    module.network
  ]

}
```

Terraform will not execute the compute module until the network module completes.

---

## Data Source Dependencies

Data sources can also participate in dependency relationships.

Example:

```hcl
data "aws_vpc" "existing" {
  id = var.vpc_id
}
```

Resource:

```hcl
resource "aws_subnet" "app" {
  vpc_id = data.aws_vpc.existing.id
}
```

Terraform recognises the dependency automatically.

---

## Dependency Cycles

Terraform cannot process circular dependencies.

Example:

```text
Resource A
     ▲
     │
     ▼
Resource B
```

Error:

```text
Cycle detected
```

Terraform will stop planning and require the dependency loop to be resolved.

---

## Common Causes of Cycles

### Mutual References

```hcl
resource_a -> resource_b
resource_b -> resource_a
```

### Module Interdependencies

```text
Module A
   │
   ▼
Module B

Module B
   │
   ▼
Module A
```

### Incorrect Outputs

Outputs that reference resources which themselves depend on consuming modules.

---

## Designing for Dependency Simplicity

Well-designed Terraform configurations should:

- Minimise unnecessary dependencies
- Avoid circular references
- Use module outputs effectively
- Reduce cross-module coupling
- Prefer implicit dependencies

Good architecture normally results in a cleaner dependency graph.

---

## Troubleshooting Dependency Issues

Common symptoms include:

### Unexpected Creation Order

Review:

```bash
terraform graph
```

Confirm dependencies exist where expected.

---

### Race Conditions

Usually indicate a missing dependency.

Consider whether:

```hcl
depends_on
```

is required.

---

### Circular Dependency Errors

Review:

- Resource references
- Outputs
- Module relationships

Refactor to break the dependency loop.

---

## Best Practices

### Do

- Prefer implicit dependencies.
- Use resource references whenever possible.
- Use module outputs to create relationships.
- Keep dependency chains simple.
- Visualise large graphs when troubleshooting.

### Don't

- Overuse `depends_on`.
- Create unnecessary dependencies.
- Build tightly coupled modules.
- Ignore circular dependency warnings.
- Introduce dependencies that are not required.

---

## Key Takeaways

- Terraform automatically builds a dependency graph from resource references.
- The dependency graph determines creation, update, and destruction order.
- Implicit dependencies are preferred over explicit dependencies.
- The `depends_on` meta-argument should only be used when Terraform cannot infer a dependency.
- Terraform uses the graph to safely parallelise resource creation.
- Circular dependencies are not supported and must be resolved.
- Understanding the dependency graph is essential when designing complex Terraform architectures and troubleshooting deployment issues.