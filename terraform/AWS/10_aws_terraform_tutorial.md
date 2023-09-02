# Terraform (AWS)
こっちのフォルダはAWSのterraformドキュメント．

## ひな形
- main.tf
```HCL2
# ---------------------------------
# Terraform configuration
# ---------------------------------
terraform {
    required_version = ">=0.13"     # 0.13以上のバージョン
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}

# ---------------------------------
# Provider
# ---------------------------------
provider "aws" {
    profile = "terraform"
    region = "ap-northeast-1"
}

# ---------------------------------
# Variables
# ---------------------------------
variable "project" {
    type = string
}

variable "env" {
    type = string
}
```

- terraform.tfvars
```HCL2
project = "Project_Name"
env = "dev"
```

