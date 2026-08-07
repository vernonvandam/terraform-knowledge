module "application" {
  source = "./modules/application"

  application_name = var.application_name
  environment      = var.environment
}