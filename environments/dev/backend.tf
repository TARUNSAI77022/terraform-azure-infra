terraform {
  backend "azurerm" {
    # You MUST replace the values below with the outputs from the setup-remote-backend.sh script
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "REPLACE_WITH_YOUR_STORAGE_ACCOUNT_NAME"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
