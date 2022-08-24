resource "azurerm_public_ip" "ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = var.ip_sku
  zones               = var.zones
}

resource "azurerm_application_gateway" "app_gw" {
  location            = var.location
  name                = var.app_gw_name
  resource_group_name = var.resource_group_name

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools

    content {
      name         = backend_address_pool.value.name
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", "") == "" ? null : split(",", backend_address_pool.value.ip_addresses)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      name                  = backend_http_settings.value.name
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = lookup(backend_http_settings.value, "request_timeout", null)
      host_name             = lookup(backend_http_settings.value, "host_name", null)
      probe_name            = lookup(backend_http_settings.value, "probe_name", null)
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration ? [""] : []

    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }

  frontend_ip_configuration {
    name = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  gateway_ip_configuration {
    name      = "${var.app_gw_name}-configuration"
    subnet_id = var.subnet_id
  }

  dynamic "http_listener" {
    for_each = var.http_listener

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = lookup(http_listener.value, "host_name", null)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
    }
  }

  dynamic "probe" {
    for_each = var.probes

    content {
      name                = probe.value.name
      host                = lookup(probe.value, "host", null)
      protocol            = probe.value.protocol
      path                = probe.value.path
      interval            = probe.value.interval
      timeout             = probe.value.timeout
      unhealthy_threshold = probe.value.unhealthy_threshold
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration

    content {
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule

    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      priority                   = request_routing_rule.value.priority
      backend_address_pool_name  = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name = lookup(request_routing_rule.value, "backend_http_settings_name", null)
    }
  }

  sku {
    name     = var.sku.size
    tier     = var.sku.tier
    capacity = lookup(var.sku, "capacity", null)
  }

  ssl_certificate {
    name = var.ssl_cert_name
  }
}
