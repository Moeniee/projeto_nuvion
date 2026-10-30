data "openstack_images_image_v2" "ubuntu" {
  name        = "Ubuntu 26.04"
  most_recent = true
}

resource "openstack_blockstorage_volume_v3" "lab_boot" {
  name     = "lab-vm-tf-boot"
  size     = 20
  image_id = data.openstack_images_image_v2.ubuntu.id
  volume_type = "SSD Standard"
}

resource "openstack_compute_instance_v2" "lab_vm" {
  name            = "lab-vm-tf"
  flavor_name     = "ST-1-0.5"
  key_pair        = openstack_compute_keypair_v2.lab_key.name
  security_groups = [openstack_networking_secgroup_v2.web.name]
  user_data = file("${path.module}/cloud-init.yaml")

  network {
    name = "Private"
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.lab_boot.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
}