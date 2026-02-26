resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "random_string" "db_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "${var.prefix}-sqlserver-${random_string.db_suffix.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = random_password.db_password.result
}

resource "azurerm_mssql_database" "sql_db" {
  name        = "${var.prefix}-sqldb"
  server_id   = azurerm_mssql_server.sql_server.id
  sku_name    = "S0"
  max_size_gb = 250
}

resource "azurerm_mssql_virtual_network_rule" "vnet_rule" {
  name      = "allow-app-subnet"
  server_id = azurerm_mssql_server.sql_server.id
  subnet_id = var.app_subnet_id
}
