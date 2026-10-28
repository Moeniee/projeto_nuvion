output "vm_private_ip" {
  value = openstack_compute_instance_v2.lab_vm.access_ip_v4
}