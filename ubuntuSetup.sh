#!/usr/bin/env bash

# Install node and git
read -p "Your domain name in these format example.com: " domain

updateLinuxPackages() {
  printf '=================================== Updating all packages ============================================ \n'
  sudo apt-get update
}

setupNodeAndGit() {
  printf '=================================== Installing Node LTS ================================================ \n'
  curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh
  sudo apt-get install nodejs -y
  export NODE_ENV=production
}

# Clone the respository from github

cloneProject() {
  printf '=============================== Cloning Respository from github ============================================== \n'
  if [[ -d More-recipes ]]; then
    rm -rf More-recipes
    git clone https://github.com/kensanni/More-recipes.git
  else 
    git clone https://github.com/kensanni/More-recipes.git
  fi
}

# Install necessary dependencies

installDependencies() {
  printf '================================ Installing project dependencies ================================================= \n'
  cd More-recipes
  git checkout chore/deploy-to-amazon-web-services
  sudo npm install --unsafe-perm
  sudo npm install -g sequelize-cli
  npm run server:build
}


# Set project environment variable

setProjectEnv() {
  sudo bash -c 'cat > .env <<EOF
  DATABASE_NAME=more-recipes
  DATABASE_USERNAME=postgres
  DATABASE_PASSWORD=keniks
  DATABASE_NAME_TEST=more-recipes-test
  DATABASE_USERNAME_TEST=postgres
  DATABASE_PASSWORD_TEST=keniks
  JWT_SECRET=kennykay
  REQUEST=https://api.cloudinary.com/v1_1/sannikay/upload
  CLOUD_PRESET=if4gv9sy
  DATABASE_URL=postgres://super_user:awsdevops@ec2-54-186-217-214.us-west-2.compute.amazonaws.com:5432/morerecipe
  EOF
  '
}

# check for nginx
installNginx() {
  sudo apt-get install nginx -y
  sudo rm -rf /etc/nginx/sites-enabled/default
  if [[ -d /etc/nginx/sites-enabled/moreRecipes  ]]; then
      printf "=================================== Removing existing configuration for nginx ======================================"
      sudo rm -rf /etc/nginx/sites-available/moreRecipes
      sudo rm -rf /etc/nginx/sites-enabled/moreRecipes
  fi
  sudo bash -c 'cat > /etc/nginx/sites-available/moreRecipes <<EOF
   server {
           listen 80;
           server_name '$domain' '$domain';
           location / {
                   proxy_pass 'http://127.0.0.1:8000';
           }
   }'
   sudo ln -s /etc/nginx/sites-available/moreRecipes /etc/nginx/sites-enabled/moreRecipes
   sudo service nginx restart
}


setupSSLCertificate() {
  printf '====================================== Setting up SSL certificate ======================================= \n'
  add-apt-repository ppa:certbot/certbot
  sudo apt-get update
  apt-get install python-certbot-nginx -y
  sudo certbot --nginx -d $domain -d $domain
}

# create background process for node
processManager() {
  cd ../More-recipes
  sequelize db:migrate
  npm install -g pm2
  printf '==================================== starting node background process ================================================= \n'
  pm2 start ecosystem.config.js
}

run() {
  updateLinuxPackages
  setupNodeAndGit
  cloneProject
  installDependencies
  setProjectEnv
  installNginx
  setupSSLCertificate
  processManager
}

run
