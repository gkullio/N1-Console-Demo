#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt-get install -y net-tools curl unzip git

ping -c 5 127.0.0.1

# --------------------------------------------------------------------
# Docker installation
# --------------------------------------------------------------------
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;

sudo apt update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Install Done" > install_done.txt;

sudo service docker start
# add your user to docker group (adjust if your admin username differs)
sudo usermod -a -G docker "${USER}" || true
sudo service docker restart

# --------------------------------------------------------------------
# F5 WAF for NGINX installation
# --------------------------------------------------------------------
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://pkgs.nginx.com/app-protect-x-plus/ubuntu `lsb_release -cs` nginx-plus\n" | \
sudo tee /etc/apt/sources.list.d/nginx-app-protect.list

sudo apt-get update -y
sudo apt-get install app-protect-module-plus -y

sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
sudo chown -R 101:101 /opt/app_protect/

# --------------------------------------------------------------------
# Registry login (as you had)
# --------------------------------------------------------------------

sudo docker login private-registry.nginx.com --username="${JWT}" --password=none

# --------------------------------------------------------------------
# Working directory for compose and pulled configs
# --------------------------------------------------------------------
sudo mkdir -p /opt/nginx/nginx-one
sudo tee /opt/nginx/nginx-one/docker-compose.yml > /dev/null <<'EOF'
${docker_compose}
EOF
sudo tee /opt/nginx/nginx-one/variables.env > /dev/null <<'EOF'
${variables_env}
EOF
sudo tee /opt/nginx/nginx-one/nginx-repo.jwt > /dev/null <<'EOF'
${nginx_jwt}
EOF

# --------------------------------------------------------------------
# PULL ONLY labs/lab2/nginx-oss and labs/lab2/nginx-plus (sparse checkout)
# Places the two folders at: /opt/nginx/nginx-one/nginx-oss and nginx-plus
# --------------------------------------------------------------------

ping -c 5 127.0.0.1

(
  cd "${WORKDIR}"

  # temp minimal repo for sparse checkout
  rm -rf nginx-one-workshops || true
  git init nginx-one-workshops
  cd nginx-one-workshops
  git remote add origin "${REPO_URL}"
  git sparse-checkout init --cone
  git sparse-checkout set labs/lab2/nginx-plus labs/lab2/nginx-oss 
  git fetch --depth=1 --filter=blob:none origin "${BRANCH}"
  git checkout "${BRANCH}"

  # move only the desired dirs next to compose file
  rm -rf "${WORKDIR}/nginx-plus" "${WORKDIR}/nginx-oss" || true
  mv labs/lab2/nginx-plus "${WORKDIR}/nginx-plus"
  mv labs/lab2/nginx-oss  "${WORKDIR}/nginx-oss"

  # cleanup temp repo
  cd "${WORKDIR}"
  rm -rf nginx-one-workshops
)

sudo openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout /opt/nginx/nginx-one/nginx-oss/etc/ssl/nginx/1-day.key -out /opt/nginx/nginx-one/nginx-oss/etc/ssl/nginx/1-day.crt -subj "/CN=g-kulland-NginxOneWorkshop"
sudo openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout /opt/nginx/nginx-one/nginx-oss/etc/ssl/nginx/30-day.key -out /opt/nginx/nginx-one/nginx-oss/etc/ssl/nginx/30-day.crt -subj "/CN=g-kulland-NginxOneWorkshop"
# --------------------------------------------------------------------
# Bring stack up
# --------------------------------------------------------------------
sudo docker compose --env-file "${WORKDIR}/variables.env" -f "${WORKDIR}/docker-compose.yml" up -d
# sudo docker compose --env-file /opt/nginx/nginx-one/variables.env -f /opt/nginx/nginx-one/docker-compose.yml up -d
# sudo docker compose -f /opt/nginx/nginx-one/docker-compose.yml up -d
# sudo docker compose --env-file /opt/nginx/nginx-one/variables.env -f /opt/nginx/nginx-one/docker-compose.yml down

sudo reboot