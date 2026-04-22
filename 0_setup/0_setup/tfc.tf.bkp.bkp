data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_project" "project" {
  name         = var.project_name
  organization = var.organization_name
}


resource "tfe_variable" "tfc_aws_provider_auth" {
  key          = "TFC_AWS_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  variable_set_id = tfe_variable_set.stacks.id
  sensitive    = false
}

resource "tfe_variable" "tfc_aws_workload_identity_audience" {
  key          = "TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE"
  value        = local.workload_identity_audience
  category     = "env"
  variable_set_id = tfe_variable_set.stacks.id
  sensitive    = false
}

resource "tfe_variable" "tfc_aws_run_role_arn" {
  key          = "TFC_AWS_RUN_ROLE_ARN"
  value        = aws_iam_role.tfc_role.arn
  category     = "env"
  variable_set_id = tfe_variable_set.stacks.id
  sensitive    = false
}

resource "tfe_variable_set" "stacks" {
  name          = "stacks"
  description   = "Variable set for Stacks"
  organization = data.tfe_organization.organization.name
}

resource "tfe_project_variable_set" "test" {
  project_id    = data.tfe_project.project.id
  variable_set_id = tfe_variable_set.stacks.id
}