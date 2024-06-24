

deployment "development" {
  variables = {
    region              = var.region
    default_tags      = { stacks-preview-example = "lambda-multi-account-stack" }
  }
}