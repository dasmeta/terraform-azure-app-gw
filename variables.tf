variable "location" {
  type        = string
  description = "The location of the resource group."
  default = "North Europe"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default = "MyResourceGroup"
}

variable "app_gw_name" {
  type        = string
  description = "The name of the Application Gateway."
  default = "appGw"
}

variable "backend_address_pools" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each backend address pool."
}

variable "backend_http_settings" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each backend http settings."
}

variable "frontend_port" {
  type        = list(map(string))
  description = "name - The name of the Frontend Port. port - The port used for this Frontend Port."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet which the Application Gateway should be connected to."
}

variable "http_listener" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each http listener."
}

variable "probes" {
  type        = list(map(string))
  default     = []
  description = "List of objects that represent the configuration of each probe."
}

variable "redirect_configuration" {
  type        = list(map(string))
  default     = []
  description = "A list of redirect_configuration blocks."
}

variable "request_routing_rule" {
  type        = list(map(string))
  description = "List of objects that represent the configuration of each backend request routing rule."
}

variable "sku" {
  type        = map(string)
  description = "A mapping with the sku configuration of the application gateway."
}

variable "ssl_cert_name" {
  type = string
  default = null
  description = "The Name of the SSL certificate that is unique within this Application Gateways."
}

variable "public_ip_name" {
  type = string
  description = "Specifies the name of the Public IP."
}

variable "allocation_method" {
  type = string
  description = "Defines the allocation method for this IP address."
  default = "Static"
}

variable "zones" {
  type = list(string)
  description = "A collection containing the availability zone to allocate the Public IP in."
  default = ["1", "2", "3"]
}

variable "ip_sku" {
  type = string
  description = "The SKU of the Public IP."
  default = "Standard"
}

variable "frontend_ip_configuration_name" {
  type = string
  description = "The name of the Frontend IP Configuration."
  default = "frontendIP"
}
