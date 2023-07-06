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



####################################################




resource "local_file" "devops-test-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "devops-key"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



resource "aws_key_pair" "devops-test-key" {
  key_name   = "devops-test-key"  # Replace with your desired key name
  public_key = tls_private_key.rsa.public_key_openssh  # Replace with the path to your public SSH key file
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-053b0d53c279acc90"  # Replace with the desired Ubuntu AMI ID
  instance_type = "t2.micro"           # Replace with the desired instance type
  key_name      = aws_key_pair.devops-test-key.key_name
  vpc_security_group_ids = []

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              EOF


  tags = {
    Name = "devops-test-app"
  }
}
