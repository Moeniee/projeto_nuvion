resource "openstack_lb_loadbalancer_v2" "lb" {
  name          = "lab-lb"
  vip_subnet_id = data.openstack_networking_subnet_v2.private.id
}

resource "openstack_lb_listener_v2" "http" {
  name            = "lab-listener-80"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

resource "openstack_lb_pool_v2" "pool" {
  name        = "lab-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.http.id
}

resource "openstack_lb_monitor_v2" "hc" {
  pool_id     = openstack_lb_pool_v2.pool.id
  type        = "HTTP"
  url_path    = "/"
  delay       = 5
  timeout     = 5
  max_retries = 3
}

resource "openstack_lb_member_v2" "members" {
  count         = var.vm_count
  pool_id       = openstack_lb_pool_v2.pool.id
  address       = openstack_compute_instance_v2.lab_vm[count.index].access_ip_v4
  protocol_port = 80
  subnet_id     = data.openstack_networking_subnet_v2.private.id
}