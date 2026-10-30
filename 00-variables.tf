variable "application_credential_id" {}
variable "application_credential_secret" {
  sensitive = true
}
variable "os_auth_url" {}
variable "os_region" {}
variable "meu_ip_cidr" {}
variable "vm_count" {
  default = 2
}