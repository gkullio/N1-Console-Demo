variable "adminSrcAddr" {}
variable "resourceOwner" {}
variable "resourceOwnerEmail" {}
variable "location" {}
variable "rg_name" {}
variable "ubuntu-hostname" {}
variable "ubuntu-username" {}
variable "ubuntu-password" {}
variable "ubuntu_instance_size" {}
variable "ubuntu_name" {}
variable "ssh_key" {}

###################### Azure VNET Variables ####################

variable "vnet_name" {}
variable "vnet_address_space" {}
variable "mgmt_subnet_name" {}
variable "mgmt_address_space" {}
variable "ext_subnet_name" {}
variable "ext_address_space" {}
variable "int_subnet_name" {}
variable "int_address_space" {}

###################### onboard.tpl Variables ####################
variable "repo_url" {}
variable "branch" {}
variable "workdir" {}


##################### NGINX One Specific ####################
# Generate a Data Plane token from the NGINX One console and place it in "dp_token" $TOKEN
# The nginx_instance_prefix is used to name the NGINX instances created by the docker compose file $NAME
# The jwt_secret is used to sign requests to login to the private NGINX Repo.  This is pulled from the MyF5 NGINX subscription
variable "dp_token" {}
variable "nginx_instance_prefix" {}
variable "jwt_secret" {}

# Azure Credentials for the providers.tf in the root 
# Azure Service Principal Information
# --Retreive from Azure Portal or CLI--Recommend using the Contributor role for the Service Principal--
# Azure CLI Example: 
# az ad sp create-for-rbac --name <name> --role Contributor --scopes /subscriptions/<your Azure subscription ID>
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}