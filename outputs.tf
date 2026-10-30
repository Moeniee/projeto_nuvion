output "vm_private_ip" {
  value = openstack_compute_instance_v2.lab_vm[*].access_ip_v4
}

output "vm_public_ip" {
  value = openstack_networking_floatingip_v2.fip.address
}

output "site_url" {
  value = "http://${openstack_networking_floatingip_v2.fip.address}"
}