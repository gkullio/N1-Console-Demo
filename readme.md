# NGINX One Console Demo Deployment with Terraform and Docker Compose

## This is designed to deploy 6 NGINX instances.<br/>(3 NGINX Plus and 3 NGINX OSS) into Microsoft Azure

## In order to use this demo, you need to perform the following steps:

### 1.  Rename the following Files:
   1. terraform.tfvars.boilerplate  --> terraform.tfvars
   2. Docker/variables.env.boilerplace  --> Docker/variables.env

### 2. Generate a Data Plane token from the NGINX One Console and save it for later use.

### 3. Either use a NGINX One evaluation license, or use the existing options available in MyF5.
   1. For the purposes of this demo, you only need the JSON Web Token.
   2. Place the JWT token in the secrets directory
      1. rename to nginx-repo.jwt
   3. Copy the contents of the JWT token in the jwt_secret variable in the terraform.tfvars file.
   

### 4. For the Docker/variables.env file, fill in the following values (NOTE: they do not need to be enclosed in quotes):
   1. TOKEN= 
      1. Data Plane Token from NGINX One Console
   2. NAME= 
      1. Prefix name for your NGINX instances deployment e.g. j-smith


### 5. For the terraform.tfvars file, fill in the following values:
   1. Ensure you have an Azure Service Principal with Contributor role.  You can do this via the Azure Portal or Azure CLI.  
      1. Example CLI command:
         1. 
         ```
         az ad sp create-for-rbac --name <name> --role Contributor --scopes /subscriptions/<your Azure subscription ID>
         ```

   2. #### Populate the terraform.tfvars file with your Azure Service Principal information 
        
        client_id\
        client_secret\
        tenant_id\
        subscription_id
        

   3. Populate the remaining fields in the terraform.tfvars file as needed
      1. NOTE*: "nginx_instance_prefix" should match the NAME value in the Docker/variables.env file.
   

### 6. Fill in the remaining required values in the terraform.tfvars file.

### 7. Run terraform commands to initialize the Terraform working directory.

-------------------------------------------------------------------------------------------------------

# terraform.tfvars variables and descriptions
# Terraform Variables Reference

This document lists all entries from `terraform.tfvars.boilerplate` to help you configure the deployment quickly.

## tfvars entries

| Section | Name | Example/Default | Notes |
|---|---|---|---|
| Core | adminSrcAddr | "[0.0.0.0/0]" | Source IP/CIDR allowed to access SSH/Web (NSGs). Comma-separated CIDRs supported. |
| Core | resourceOwner | "" | Tag: owner |
| Core | resourceOwnerEmail | "" | Tag: email |
| Core | location | "westus2" | Azure region (e.g., eastus) |
| Core | rg_name | "" | Azure Resource Group name |
| Core | ubuntu-hostname | "nginx-1-host" | VM hostname |
| Core | ubuntu-username | "azure" | Admin username |
| Core | ubuntu-password | "" | Admin password (if used; SSH key preferred) |
| Core | ubuntu_name | "nginx-1-vm" | VM resource name |
| Core | ubuntu_instance_size | "Standard_D2_v5" | VM size |
| Core | ssh_key | "~/.ssh/id_rsa.pub" | Path to public SSH key |

| Section | Name | Example/Default | Notes |
|---|---|---|---|
| Azure VNET | vnet_name | "" | Virtual network name |
| Azure VNET | vnet_address_space | "172.20.0.0/16" | VNet CIDR |
| Azure VNET | mgmt_subnet_name | "mgmt" | Management subnet name |
| Azure VNET | mgmt_address_space | "172.20.0.0/24" | Management subnet CIDR |
| Azure VNET | int_subnet_name | "internal" | Internal subnet name |
| Azure VNET | int_address_space | "172.20.2.0/24" | Internal subnet CIDR |

| Section | Name | Example/Default | Notes |
|---|---|---|---|
| onboard.tpl | repo_url | "https://github.com/gkullio/N1-Console-Demo.git" | Repo cloned and copied into workdir for Docker Compose |
| onboard.tpl | branch | "main" | Branch to use |
| onboard.tpl | workdir | "/opt/nginx/nginx-one" | Working directory for NGINX/compose assets |

| Section | Name | Example/Default | Notes |
|---|---|---|---|
| NGINX One | dp_token | "" | Data Plane token from NGINX One console ($TOKEN) |
| NGINX One | nginx_instance_prefix | "" | Prefix used to name NGINX instances ($NAME) |
| NGINX One | jwt_secret | "" | Secret to sign requests for private NGINX Repo (from MyF5 subscription) |

| Section | Name | Example/Default | Notes |
|---|---|---|---|
| Azure SP | client_id | "" | Service Principal Application (client) ID |
| Azure SP | client_secret | "" | Service Principal secret |
| Azure SP | tenant_id | "" | Azure AD tenant ID |
| Azure SP | subscription_id | "" | Azure subscription ID |

## How to use

- Copy `terraform.tfvars.boilerplate` to `terraform.tfvars`.
- Fill in the values in `terraform.tfvars` using the examples above as a guide.
- Keep secrets out of source control; consider using environment variables or a secrets backend.

