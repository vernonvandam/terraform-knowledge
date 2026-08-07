# Providers

Providers are plugins that manage an API or service. Declare a source address and version requirement in `terraform.required_providers`; configure operational settings in a top-level provider block.

```hcl
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}
```

Requirements select the plugin. Configuration supplies settings such as a region or credentials. Root modules own configuration; reusable modules declare requirements and inherit configuration. Never put provider versions in a provider block or credentials in configuration files.