terraform {
  cloud {
    organization = "Softbank-hackathon-Grape"

    workspaces {
      name = "grapevine-infra"
    }
  }
}

provider "aws" {
  region  = var.region

  default_tags {
    tags = var.common_tags
  }
}