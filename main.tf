terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_cognito_user_pool" "pool" {

  name = "devops-test"
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true
  }

  # schema {
  #   name = "name"
  #   attribute_data_type = "String"
  #   required = true
  # }

}

resource "aws_cognito_user_pool_client" "client" {

  name = "devops-test-client"
  user_pool_id = aws_cognito_user_pool.pool.id
  generate_secret     = true
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]

}

output "user_pool_id" {

  value = aws_cognito_user_pool.pool.id

}

output "app_client_id" {

  value = aws_cognito_user_pool_client.client.id

}
