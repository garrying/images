variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = ["wave"]
}

variable "environment" {
  description = "Additional environment variables to set in the image."
  type        = map(string)
  default     = {}
}

module "accts" { source = "../../../tflib/accts" }

output "config" {
  value = jsonencode({
    contents = {
      packages = var.extra_packages
    }
    accounts = module.accts.block
    entrypoint = {
      command = "/usr/bin/wave"
    }
  })
}
