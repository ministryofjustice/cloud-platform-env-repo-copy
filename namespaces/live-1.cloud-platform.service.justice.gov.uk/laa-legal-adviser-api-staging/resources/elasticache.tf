module "celery-broker" {
  source                 = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=3.1"
  cluster_name           = "${var.cluster_name}"
  cluster_state_bucket   = "${var.cluster_state_bucket}"
  team_name              = "${var.team_name}"
  application            = "${var.application}"
  is-production          = "${var.is-production}"
  node_type              = "cache.t2.micro"
  environment-name       = "${var.environment-name}"
  infrastructure-support = "${var.email}"

  providers = {
    aws = "aws.london"
  }
}

resource "kubernetes_secret" "celery-broker" {
  metadata {
    name      = "celery-broker"
    namespace = "${var.namespace}"
  }

  data {
    url                      = "redis://:${module.celery-broker.auth_token}@${module.celery-broker.primary_endpoint_address}:6379"
    primary_endpoint_address = "${module.celery-broker.primary_endpoint_address}"
    auth_token               = "${module.celery-broker.auth_token}"
  }
}
