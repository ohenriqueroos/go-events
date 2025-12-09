terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Altere para sua região
}

# Zipar o binário Go antes de subir
data "archive_file" "ingest_zip" {
  type        = "zip"
  source_file = "../bin/bootstrap" # A AWS Amazon Linux 2023 exige que o binário chame 'bootstrap'
  output_path = "../bin/ingest.zip"
}
