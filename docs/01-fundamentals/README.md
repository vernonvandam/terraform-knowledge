# Terraform fundamentals

Terraform declares desired infrastructure, builds a dependency graph, compares that desired state with state and remote objects, and proposes the actions needed to converge.

Read in order: [overview](terraform-overview.md), [infrastructure as code](infrastructure-as-code.md), [providers](providers.md), [resources](resources.md), [data sources](data-sources.md), and [lifecycle](terraform-lifecycle.md).

```shell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Treat `plan` as the decision point. Inspect it before applying, especially replacements and destroys. Start with the [basic example](../../examples/basics/README.md).