# deployments.tfdeploy.hcl
# Defines the deployment targets for the demostack stack.
# Each deployment maps to one context (set of variable values) and
# controls orchestration (e.g. whether clusters are applied in parallel or sequentially).

# ---------------------------------------------------------------------------
# Identity token for HCP Terraform workload identity (OIDC)
# Remove / adjust if you use static AWS credentials instead.
# ---------------------------------------------------------------------------

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

# ---------------------------------------------------------------------------
# Deployment: primary  (eu-west-2)
# The primary cluster is applied first; secondary & tertiary depend on it
# so that the primary datacenter value is available for mesh gateway config.
# ---------------------------------------------------------------------------

deployment "primary" {
  inputs = {
    # Deployment-level AWS credential wiring (OIDC / workload identity)
    # Replace with var references to HCP Terraform variable sets as needed.
    owner      = "your-iam-user"
    public_key = "<your-ssh-public-key>"
    se_region  = "EMEA"
    purpose    = "Hashistack Demo"
    name       = "demostack"

    servers = 3
    workers = 3

    enterprise    = false
    vaultlicense  = ""
    consullicense = ""
    nomadlicense  = ""

    TTL            = "240"
    sleep_at_night = true
    created_by     = "Terraform Stacks"
  }
}

# ---------------------------------------------------------------------------
# Deployment: secondary  (eu-east-1)
# ---------------------------------------------------------------------------

deployment "secondary" {
  inputs = {
    owner      = "your-iam-user"
    public_key = "<your-ssh-public-key>"
    se_region  = "EMEA"
    purpose    = "Hashistack Demo"
    name       = "demostack"

    servers = 3
    workers = 3

    enterprise    = false
    vaultlicense  = ""
    consullicense = ""
    nomadlicense  = ""

    TTL            = "240"
    sleep_at_night = true
    created_by     = "Terraform Stacks"
  }
}

# ---------------------------------------------------------------------------
# Deployment: tertiary  (ap-northeast-1)
# ---------------------------------------------------------------------------

deployment "tertiary" {
  inputs = {
    owner      = "your-iam-user"
    public_key = "<your-ssh-public-key>"
    se_region  = "APAC"
    purpose    = "Hashistack Demo"
    name       = "demostack"

    servers = 3
    workers = 3

    enterprise    = false
    vaultlicense  = ""
    consullicense = ""
    nomadlicense  = ""

    TTL            = "240"
    sleep_at_night = true
    created_by     = "Terraform Stacks"
  }
}
