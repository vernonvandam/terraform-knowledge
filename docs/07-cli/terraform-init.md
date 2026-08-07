# `terraform init`

`terraform init` prepares a working directory by initialising the backend and installing providers and modules.

```shell
terraform init
```

Run it after cloning a root module, changing backend configuration, changing provider or module requirements, or updating the dependency lock file. For a local validation workflow that must not access the real backend, use `terraform init -backend=false`.

Use `-upgrade` only for a deliberate dependency upgrade: it can select newer versions and update `.terraform.lock.hcl`. Review and commit intended lock-file changes.