provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
    features {}
}

variable "location" {
  description = "The location where the Azure resources will be created."
  type        = string
  default     = "eastus"
}

variable "subscription_id" {
    description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
    description = "Enter Client ID for provisioning resources in Azure"
}

variable "client_secret" {
    description = "Enter Client Secret for provisioning resources in Azure"
}

variable "tenant_id" {
    description = "Enter Tenant ID for provisioning resources in Azure"
}

variable "subnets" {
    type        = map
    description = "List of subnets and address"
    default= {
    "snet-web" = "10.222.10.0/24"
    "snet-app" = "10.222.15.0/24"
    "snet-db" = "10.222.20.0/24"
    "snet-logs" = "10.222.5.0/24"
    }
}

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}