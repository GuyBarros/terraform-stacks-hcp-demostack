# terraform-aws-demostack — Terraform Stacks Migration

This directory contains the **Terraform Stacks** version of
[guyBarros/terraform-aws-demostack](https://github.com/guyBarros/terraform-aws-demostack).

> **The existing `modules/` directory is completely unchanged.**
> Stacks wraps it — no module code needs to be touched.

---

## What changed and why

| Original (root module)                      | Stacks equivalent                               |
|---------------------------------------------|-------------------------------------------------|
| `for_each = var.clusters` in `main.tf`      | One `component` block per cluster in `.tfstack.hcl` |
| Single `terraform.tfvars` for all regions   | `deployments.tfdeploy.hcl` with per-deployment `inputs` |
| Single AWS provider (region commented out)  | Three aliased `provider "aws"` blocks in `providers.tfstack.hcl` |
| `random_id` resources at root level         | Moved inside the component so each cluster has its own secrets |
| One state file                              | HCP Terraform manages isolated state per component per deployment |

---

## Directory layout

```
.
├── demostack.tfstack.hcl           # Stack definition: components + stack outputs
├── providers.tfstack.hcl           # Provider requirements and per-region configs
├── deployments.tfdeploy.hcl        # Deployment targets (primary / secondary / tertiary)
├── components/
│   └── hashistack-cluster/
│       ├── main.tf                 # Calls the existing ./modules directory
│       ├── variables.tf            # Component inputs
│       └── outputs.tf              # Component outputs (surfaced to stack)
└── modules/                        # ← ORIGINAL unchanged module code lives here
```

---

## Prerequisites

- **Terraform >= 1.8** with Stacks support (currently requires HCP Terraform or the
  `terraform stacks` preview CLI).
- An HCP Terraform organisation with the Stacks feature enabled.
- AWS credentials configured as a **Variable Set** or via OIDC workload identity
  in HCP Terraform (recommended — see `identity_token "aws"` in `deployments.tfdeploy.hcl`).

---

## Getting started

### 1. Clone and copy module code

```bash
git clone https://github.com/guyBarros/terraform-aws-demostack.git
cp -r terraform-aws-demostack/modules ./modules
```

### 2. Edit `deployments.tfdeploy.hcl`

Replace the placeholder values:

```hcl
owner      = "your-iam-user"
public_key = "<your-ssh-public-key>"
```

For **enterprise** usage add your licence strings:

```hcl
enterprise    = true
vaultlicense  = "02MV4..."
consullicense = "02MV4..."
nomadlicense  = "02MV4..."
```

### 3. Push to HCP Terraform

```bash
# Point your HCP Terraform workspace at this directory as the stack source.
# Then trigger a plan via the UI or CLI:
terraform login
terraform init
terraform plan
```

### 4. Selective deployment

Because each cluster is an independent component, you can target a single region:

```
# HCP Terraform UI → Stacks → select component → Plan / Apply
```

Or with the CLI preview:

```bash
terraform stacks plan -target=component.primary
terraform stacks apply -target=component.primary
```

---

## Key design decisions

### Why explicit components instead of `for_each` on a component?

The original code used `for_each` on a `module` block to fan out across regions.
Terraform Stacks **does** support `for_each` on components, but explicit named
components (`primary`, `secondary`, `tertiary`) are preferred here because:

- Each deployment can have its own `inputs` block, making per-region overrides
  (instance sizes, licence keys, CIDR ranges) straightforward without conditionals.
- The dependency graph in HCP Terraform is clearer — you can apply `primary`
  independently before `secondary` or `tertiary`.
- Stack outputs use named keys (`primary`, `secondary`, `tertiary`) rather than
  opaque indices.

### Provider instances

The original provider block had the region commented out, relying on environment
variables. In Stacks the provider configuration is explicit and immutable at
plan time, so each region gets its own named provider instance
(`provider.aws.primary`, `provider.aws.secondary`, `provider.aws.tertiary`).

### Secret handling

`random_id` resources for gossip keys and join tokens have been moved **inside
the component**. This means each cluster generates its own independent secrets,
which is correct for a multi-region mesh where clusters should not share
encryption keys. The sensitive outputs are marked `sensitive = true` and are
only accessible within the stack's encrypted state.

---

## Outputs

After a successful apply the stack surfaces:

| Output            | Description                              |
|-------------------|------------------------------------------|
| `consul_urls`     | Map of Consul UI URLs per cluster        |
| `vault_urls`      | Map of Vault UI URLs per cluster         |
| `nomad_urls`      | Map of Nomad UI URLs per cluster         |
| `fabio_endpoints` | Map of Fabio LB endpoints per cluster    |
| `boundary_urls`   | Map of Boundary UI URLs per cluster      |

---

## Troubleshooting

Cloud-init logs on the nodes (unchanged from original):

```bash
sudo tail -f /var/log/cloud-init-output.log
```
