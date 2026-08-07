# Data sources

Data sources query existing information but do not take ownership of it.

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

Use them for shared or externally managed objects. Make lookups deterministic with explicit IDs or filters, and remember values unknown until apply can affect plan-time iteration. A data source needs only the read permissions appropriate to the lookup.