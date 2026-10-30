resource "openstack_networking_secgroup_v2" "web" {
  name        = "lab-web-sg"
  description = "SSH restrito ao meu IP e HTTP aberto"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.meu_ip_cidr
  security_group_id = openstack_networking_secgroup_v2.web.id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.web.id
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id
  depends_on  = [openstack_networking_router_interface_v2.lab_router_if]
}

data "openstack_networking_network_v2" "public" {
  name = "public"
}

data "openstack_networking_network_v2" "private" {
  name = "Private"
}

data "openstack_networking_subnet_v2" "private" {
  network_id = data.openstack_networking_network_v2.private.id
}

resource "openstack_networking_router_v2" "lab_router" {
  name                = "lab-router"
  external_network_id = data.openstack_networking_network_v2.public.id
}

resource "openstack_networking_router_interface_v2" "lab_router_if" {
  router_id = openstack_networking_router_v2.lab_router.id
  subnet_id = data.openstack_networking_subnet_v2.private.id
}