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
   
### 7. Run terraform init to initialize the Terraform working directory.
        terraform init\
        terraform plan\
        terraform apply -auto-approve
   


