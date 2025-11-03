# NGINX One Console Demo Deployment with Terraform and Docker Compose

## This is designed to deploy 6 NGINX instances.<br/>(3 NGINX Plus and 3 NGINX OSS) into Microsoft Azure

## In order to use this demo, you need to perform the following steps:

### 1.  Rename the following Files:
   1. terraform.tfvars.boilerplate  --> terraform.tfvars
   2. Docker/variables.env.boilerplace  --> Docker/variables.env

### 2. Generate a Data Plane token from the NGINX One Console
   1. Log into NGINX One Console
   2. Navigate to Manage --> Data Plane Keys
   3. Create a new Data Plane Token
      1. Give it a name e.g. "n1-console-demo"
      2. Give it an expiration date
      3. Click Create Token
      4. Copy the generated token to a safe place as you will need it in the next steps.

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
   1. #### Ensure you have an Azure Service Principal with Contributor role.  You can do this via the Azure Portal or Azure CLI.  
      1.  Example CLI command:
         ```
         az ad sp create-for-rbac --name <name> --role Contributor --scopes /subscriptions/<your Azure subscription ID>
         ```

   2. #### Populate the terraform.tfvars file with your Azure Service Principal information 
        
        client_id\
        client_secret\
        tenant_id\
        subscription_id
        

   3. #### Populate the Resource Owner and Resource Owner Email fields with your information

   4. #### Populate the dp_token field with the Data Plane Token from NGINX One Console

   5. #### Populate the jwt_secret field with the contents of the JWT token from MyF5

   6. #### Update any other variables as needed (e.g., location, VM size, etc.)   


### 6. Run terraform commands to initialize the Terraform working directory.

-------------------------------------------------------------------------------------------------------


# Terraform Variables Reference
### terraform.tfvars variables and descriptions

This document lists all entries from `terraform.tfvars.boilerplate` to help you configure the deployment quickly.

## tfvars entries

## Section: Ubuntu VM Variables
| Name | Example/Default | Notes |
|---|---|---|
| adminSrcAddr | "[0.0.0.0/0]" | Source IP/CIDR allowed to access SSH/Web (NSGs). Comma-separated CIDRs supported. |
| resourceOwner | "" | Tag: owner |
| resourceOwnerEmail | "" | Tag: email |
| location | "westus2" | Azure region (e.g., eastus) |
| rg_name | "N1-console-demo" | Azure Resource Group name |
| ubuntu-hostname | "nginx-1-host" | VM hostname |
| ubuntu-username | "azureuser" | Admin username |
| ubuntu-password | "Azure123!@" | Admin password (if used; SSH key default) |
| ubuntu_name | "nginx-1-vm" | VM resource name |
| ubuntu_instance_size | "Standard_D2_v5" | VM size |
| ssh_key | "~/.ssh/id_rsa.pub" | Path to public SSH key |

## Section: Azure VNET Variables
| Name | Example/Default | Notes |
|---|---|---|
| vnet_address_space | "172.20.0.0/16" | VNet CIDR |
| mgmt_subnet_name | "mgmt" | Management subnet name |
| mgmt_address_space | "172.20.0.0/24" | Management subnet CIDR |
| int_subnet_name | "internal" | Internal subnet name |
| int_address_space | "172.20.2.0/24" | Internal subnet CIDR |

## Section: Onboarding Template Variables
| Name | Example/Default | Notes |
|---|---|---|
| repo_url | "https://github.com/gkullio/N1-Console-Demo.git" | Repo cloned and copied into workdir for Docker Compose |
| branch | "main" | Branch to use |
| workdir | "/opt/nginx/nginx-one" | Working directory for NGINX/compose assets |

## Section: NGINX One Console
| Name | Example/Default | Notes |
|---|---|---|
| dp_token | "" | Data Plane token from NGINX One console ($TOKEN) |
| nginx_instance_prefix | "test-nginx" | Prefix used to name NGINX instances ($NAME) |
| jwt_secret | "" | Secret to sign requests for private NGINX Repo (from MyF5 subscription) |

## Section: Azure Service Principal 
| Name | Example/Default | Notes |
|---|---|---|
| client_id | "" | Service Principal Application (client) ID |
| client_secret | "" | Service Principal secret |
| tenant_id | "" | Azure AD tenant ID |
| subscription_id | "" | Azure subscription ID |

## How to use

- Fill in the values in `terraform.tfvars` using the examples above as a guide.
- Keep secrets out of source control; consider using environment variables or a secrets backend.

