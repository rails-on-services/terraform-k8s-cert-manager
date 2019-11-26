variable "crd_depends_on" {
  type        = any
  default     = null
  description = "Variable to pass dependancy on module" # https://discuss.hashicorp.com/t/tips-howto-implement-module-depends-on-emulation/2305/2
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "Namespace to deploy cert-manager resources"
}

variable "version" {
  type        = string
  default     = "v0.11.0"
  description = "Cert-manager version. NOTE: CRD files has to be generated manually accordingly to choosen version"
}
