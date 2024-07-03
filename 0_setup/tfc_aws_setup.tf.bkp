module "tfc-dynamic-creds-provider" {
  source  = "hashi-strawb/tfc-dynamic-creds-provider/aws"
  version = "0.1.0"
}


output "aws_oidc_provider" {
  value = module.tfc-dynamic-creds-provider.oidc_provider
}

data "tfe_project" "demostack" {
  name = var.tfc_workspace_project_name
  organization = var.tfc_organization_name
}

module "tfc-dynamic-creds-workspace" {
    depends_on = [ module.tfc-dynamic-creds-provider ]
  source = "github.com/GuyBarros/terraform-aws-tfc-dynamic-creds-workspace"
  
  # insert the 3 required variables here
  oidc_provider_arn = module.tfc-dynamic-creds-provider.oidc_provider.arn
  tfc_organization_name = var.tfc_organization_name
  tfc_workspace_project_name = var.tfc_workspace_project_name
  tfc_workspace_project_id = data.tfe_project.demostack.id
  cred_type = "project"
}
