variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
  default = "GuyBarros"
}

variable "tfc_workspace_project_name" {
  type        = string
  description = "The name of the project the workspace lives in"
  default     = "Demostack"

}