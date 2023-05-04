# Define additional variables
variable "allowed_ssh_ips" {
  description = "List of allowed IP addresses for SSH access."
  type        = list(string)
  default     = ["x.x.x.x/32", "y.y.y.y/32"]
}

# Use random_pet for generating unique names
resource "random_pet" "vnet_name" {
  prefix = "vnet-"
}

resource "random_pet" "subnet_name" {
  prefix = "subnet-"
}

# Update VNet and subnet resources with random_pet names
resource "azurerm_virtual_network" "vnet" {
  name                = random_pet.vnet_name.id
  # (rest of the code remains unchanged)
}

resource "azurerm_subnet" "subnet" {
  name                 = random_pet.subnet_name.id
  # (rest of the code remains unchanged)
}

# Update the existing network security group with the SSH security rule
resource "azurerm_network_security_group" "nsg" {
  # (rest of the code remains unchanged)

  security_rule {
    name                         = "Allow_SSH"
    priority                     = 400
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "22"
    source_address_prefixes      = var.allowed_ssh_ips
    destination_address_prefixes = ["*"]
  }
}
