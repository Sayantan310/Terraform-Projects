terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.65.0"
    }
  }
}

provider "azurerm" {  
  client_id = "08bcc6d2-9955-4498-9d57-09a8a2ed7ba6"
  client_secret = "Mag8Q~C7hp~SXYIMSW6jTTUINgO1.GGGTlXtAb5m"
  tenant_id = "e531b636-591f-468a-b7db-560254b22f71"
  subscription_id = "d08202be-b5f1-4e6f-9a1d-880443055ed2"
  features {}
}