resource "openstack_compute_keypair_v2" "lab_key" {
  name       = "lab-terraform-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}