# Provider configuration
provider "azurerm" {
  features {}
}

# Variables for environment-specific names
variable "environment" {
  description = "The environment to deploy to (dev, uat, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-test"
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
  default     = "vnet-test"
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = "East US"
}

# Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
