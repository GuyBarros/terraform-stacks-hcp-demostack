variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
}



variable "postgres_username" {
  description = "Username that will be used to create the AWS Postgres instance"
  default     = "postgresql"
}

variable "postgres_password" {
  description = "Password that will be used to create the AWS Postgres instance"
  default     = "YourPwdShouldBeLongAndSecure!"
}

  variable "postgres_db_name" {
  description = "Db_name that will be used to create the AWS Postgres instance"
  default     = "postgress"
}

variable "mysql_username" {
  description = "Username that will be used to create the AWS mysql instance"
  default     = "foo"
}

variable "mysql_password" {
  description = "Password that will be used to create the AWS mysql instance"
  default     = "YourPwdShouldBeLongAndSecure!"
}

  variable "mysql_db_name" {
  description = "Db_name that will be used to create the AWS mysql instance"
  default     = "mydb"
}

variable "documentdb_master_username" {
  description = "Username that will be used to create the AWS Postgres instance"
  default     = "postgresql"
}

variable "documentdb_master__password" {
  description = "Password that will be used to create the AWS Postgres instance"
  default     = "YourPwdShouldBeLongAndSecure!"
}
