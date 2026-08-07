# Provider aliases

Provider aliases let one root module configure more than one instance of the same provider, such as two regions or accounts.

```hcl
provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "secondary"
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "example-secondary-bucket"
}
```

Pass an alias explicitly to a child module when it must use that configuration:

```hcl
module "replica" {
  source = "../../modules/replica"
  providers = { aws = aws.secondary }
}
```

Aliases make deployment targets explicit. Name them for their role, not a temporary implementation detail, and keep credentials and permissions separated where environments or accounts differ.