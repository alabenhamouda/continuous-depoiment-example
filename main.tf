terraform {
    required_providers  {
        azurerm =   {
            source  =   "hashicorp/azurerm"
        }
    }
    backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstate10403"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

provider "azurerm" {
  client_id       =   var.client_id
  client_secret   =   var.client_secret
  subscription_id =   var.subscription_id
  tenant_id       =   var.tenant_id

  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "cd-test-rg"
  location = "westeurope"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "cd-app-service-plan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "cd-app-service"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id = azurerm_service_plan.app_service_plan.id

  site_config {
    always_on = true
  }
}

output "app_service_url" {
  value = azurerm_linux_web_app.web_app.default_hostname
}
