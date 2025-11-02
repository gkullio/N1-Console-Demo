adminSrcAddr                = ["73.11.176.78", "104.219.105.84/32","162.220.44.18/32","200.94.108.146/32","104.219.107.84/32","65.61.116.107/32", "67.185.28.238", "67.139.111.130"]
resourceOwner               = "Gage Kulland"
resourceOwnerEmail          = "g.kulland@f5.com"
location                    = "westus2"
rg_name                     = "gkulland-nginx-one"
ubuntu-hostname             = "n1-server"
ubuntu-username             = "kulland"
ubuntu-password             = "WOLF0359ab@"
ubuntu_instance_size        = "Standard_D2_v5"
ubuntu_name                 = "kulland-ubuntu"
ssh_key                     = "~/.ssh/id_rsa.pub"

###################### Azure VNET Variables ####################

vnet_name                   = "kulland-nginx-one-vnet"
vnet_address_space          = "172.20.0.0/16"
mgmt_subnet_name            = "management"
mgmt_address_space          = "172.20.0.0/24"
ext_subnet_name             = "external"
ext_address_space           = "172.20.1.0/24"
int_subnet_name             = "internal"
int_address_space           = "172.20.2.0/24"

###################### onboard.tpl Variables ####################
repo_url                    = "https://github.com/nginxinc/nginx-one-workshops.git"
branch                      = "main"
workdir                     = "/opt/nginx/nginx-one"


##################### NGINX One Specific ####################
# Generate a Data Plane token from the NGINX One console and place it in "dp_token" $TOKEN
# The nginx_instance_prefix is used to name the NGINX instances created by the docker compose file $NAME
# The jwt_secret is used to sign requests to login to the private NGINX Repo.  This is pulled from the MyF5 NGINX subscription
dp_token                    = "5gGw1uB+janvYGUFEDEOv8SwiUtGbO9yQANmnYS85Ls="
nginx_instance_prefix       = "g-kulland"
jwt_secret                  = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6InYxIiwiamt1IjoiaHR0cHM6Ly9wcm9kdWN0LmFwaXMuZjUuY29tL2VlL3YxL2tleXMvandrcyJ9.eyJzdWIiOiJGTkktOTczYzk0ZGUtYjkzYS00NDY1LWIwN2ItNTE0YTAwMjljMDU4IiwiaWF0IjoxNzI2Nzg0OTI4LCJpc3MiOiJGNSBJbmMuIiwiYXVkIjoidXJuOmY1OnRlZW0iLCJqdGkiOiI4YTBhNjI3MC03NmQ2LTExZWYtOWQ4OS1lOTU5YThiODBlNjUiLCJmNV9vcmRlcl90eXBlIjoicGFpZCIsImY1X3NhdCI6MTc4MzkwMDgwMH0.OWnFlm6nE5ObXm_1yO3QNgWxKyhF0An3sGqS8ja1ASXcs1VQwDTPl7KCQGRHUfCwkN5lTHn5AgC2t5XaLcUY1fN5zpkOeWE7BVLjhsyL9M3P2GuGGf2h6wcIbbFCsrov1QVJONzeS_vGlpIFuIYahTvYwFFNbASTk5dUWiJPJ2uxtJfaCfV5CGGfqqewDZrPEqVeccIM47BOfiVVJWZbUFcMp-CbuPEyqAyR_ZrY-i26NUeQOJ13RD899JDlBQepuM9eo14JmgizZAJkZYGn-sl1ox39gjFlZ4BydyoYIyxY-CN-O6tYkjSg2LYkTZu8xivpIAV7i6f7H8nzcWwpVlMXhg_o_U8GFiAS2-DugjTQN1rW9qfz56DcAFi-A79zyX9YvvLhd-7WHMP7f0y73oPhqxRB6Du5hNK_BBggHWJAgohFrlRT3KKU5duZKdfLEEqpbXHp0qUihmY7neRxAhtdAKbj4KyjWKo_pWJgvXqVt0aIS1IoAODneBtWpo-3qd2rpL28mcc1TJZVh6WwNDn9e9qsgvbUBe5Kipmxd0drNERjsHjOEFUC2N3sVOy4UGVAI14aQaFyVxNWGwou4xNYWQCnLjlF5v2Fkd2811hqc1z0NVz--J1NfW92WJ8FiytuxFpuQTgoLOZQ5mBa6UigTf9P_gEeQgOxw8r4jAI"

#################### Azure Service Principal ####################
client_id                   = "1ead3967-4315-44c1-94c6-0b5991eecc52"
client_secret               = "0lt8Q~AM50LV71.BviaXyBpnT4cvTrvSF-5Kaazi"
tenant_id                   = "e569f29e-b098-4cea-b6f0-48fa8532d64a"
subscription_id             = "4bd08e66-f1da-40f0-9de0-237567f7e61b"