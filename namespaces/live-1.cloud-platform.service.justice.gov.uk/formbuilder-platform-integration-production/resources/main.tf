# auto-generated from fb-cloud-platforms-environments
erraform {
backend "s3" {}
}

provider "aws" {
region = "eu-west-2"
}

provider "aws" {
alias  = "london"
region = "eu-west-2"
}
