# Flattening nested collections

Flatten grouped input when the provider manages children independently, then use a stable composite key for `for_each`.

```hcl
locals {
  subnets = {
    for item in flatten([
      for network_key, network in var.networks : [
        for subnet_key, subnet in network.subnets : {
          key  = "${network_key}.${subnet_key}"
          cidr = subnet.cidr
        }
      ]
    ]) : item.key => item
  }
}
```

Avoid this when the provider models children as nested blocks. Changing the composite key changes the resource address.