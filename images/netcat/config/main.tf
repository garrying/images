locals {
  baseline_packages = ["busybox", "netcat-openbsd"]
}

module "accts" {
  source = "../../../tflib/accts"
}

terraform {
  required_providers {
    apko = { source = "chainguard-dev/apko" }
  }
}

variable "extra_packages" {
  default     = ["netcat-openbsd"]
  description = "The additional packages to install (e.g. netcat-openbsd)."
}

output "config" {
  value = jsonencode({
    "contents" : {
      // TODO: remove the need for using hardcoded local.baseline_packages by plumbing
      // these packages through var.extra_packages in all callers of this config module
      "packages" : distinct(concat(local.baseline_packages, var.extra_packages))
    },
    "entrypoint" : {
      "command" : "/usr/bin/nc"
    },
    "cmd" : "-h",
    "work-dir" : "/home/nc",
    "accounts" : module.accts.block
  })
}

