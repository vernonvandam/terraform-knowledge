# Remote state

A remote backend stores state outside the local working directory so a team and its automation use the same source of truth.

```hcl
terraform {
  backend "s3" {
    bucket = "example-terraform-state"
    key    = "production/network.tfstate"
    region = "ap-southeast-2"
  }
}
```

Backend configuration cannot use normal variables or resource references. Supply sensitive backend settings through an approved mechanism rather than committing credentials. Choose a backend that supports access control, encryption, durable storage, and locking where possible.

`terraform_remote_state` can consume a deliberately published output, but it also grants access to the entire state snapshot. Prefer a more narrowly scoped interface when that exposure is unacceptable.