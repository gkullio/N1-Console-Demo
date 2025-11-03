# Create resource group
resource "azurerm_resource_group" "rg" {
    name                 = "${var.rg_name}-${random_id.random_id.hex}-rg"
    location             = var.location
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  byte_length = 4
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS" 
  public_network_access_enabled = false
  allow_nested_items_to_be_public = false
  depends_on = [ azurerm_resource_group.rg ]
}