# Provider configuration

A provider configuration supplies operational settings for a provider, such as region, endpoint, subscription, or authentication mechanism. Keep it in the root module so the caller controls where changes are made.

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
```

Declare the provider source and version in `required_providers`, not in this block. Avoid credentials in configuration: use the provider's supported environment variables, workload identity, or approved credential process. A provider configuration must remain available while state still contains resources created through it.