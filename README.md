This module creates Application Gateway associated with a Public IP and with a Subnet in Azure.

## Usage
```
module "app_gw" {
  source = "../terraform-azure-app-gw"

  location            = local.location
  resource_group_name = local.resource_group_name
  app_gw_name                = "applicationGateway"

  public_ip_name = "appGwPublicIP"
  subnet_id = "subnet_id
  backend_address_pools = [
    {
        name = "bepool"
    },
  ]

  backend_http_settings = [
    {
        cookie_based_affinity = "Disabled"
        name                  = "setting"
        port                  = 80
        protocol              = "Http"
    },
  ]
  
  frontend_ip_configuration_name = "appGatewayFrontendIP"

  frontend_port = [
    {
        name = "httpsPort"
        port = 443
    },
    {
        name = "httpPort"
        port = 80
    },
  ]

  http_listener = [
    {
        frontend_ip_configuration_name = "appGatewayFrontendIP"
        frontend_port_name             = "httpPort"
        name                           = "httpListener"
        protocol                       = "Http"
    }
  ]

  request_routing_rule = [
      {
        backend_address_pool_name  = "bepool"
        backend_http_settings_name = "setting"
        http_listener_name         = "httpListener"
        name                       = "rule1"
        priority                   = 10010
        rule_type                  = "Basic"
      }
  ]

  sku = {
    capacity = 2
    size     = "Standard_v2"
    tier     = "Standard_v2"
  }
}
```
