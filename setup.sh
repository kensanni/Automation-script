#!/usr/bin/env bash

# Install node and git

updateLinuxPackages() {
  printf '=================================== Updating all packages ============================================ \n'
  sudo yum update -y
}

setupNodeAndGit() {
  printf '=================================== Installing Node LTS ================================================ \n'
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  source ~/.bashrc
  nvm install --lts
  printf '==================================== Installing Git ====================================================== \n'
  sudo yum install git
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
  npm install babel-preset-stage-2 
  npm install  -g babel-preset-env
  npm install -g nodemon
  npm install  -g babel-cli
  npm install  -g babel-runtime
  npm install -g babel-plugin-transform-regenerator
  npm install -g sequelize-cli
  npm install
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
  '
}

# check for nginx
installNginx() {
  sudo yum install nginx -y
}


setupSSLCertificate() {
  read -p "Your domain name in these format example.com: " domain
  printf '====================================== Setting up SSL certificate ======================================= \n'
  cd ../
  git clone https://github.com/letsencrypt/letsencrypt
  cd letsencrypt/
  service nginx stop
  ./letsencrypt-auto certonly --debug --standalone -d final-test.tk
  sudo rm -rf /etc/nginx/nginx.conf
  sudo cp /etc/letsencrypt/live/"$domain"/fullchain.pem /etc/nginx/fullchain.pem
  sudo cp /etc/letsencrypt/live/"$domain"/privkey.pem /etc/nginx/privkey.pem
  sudo cp ../nginx.conf /etc/nginx/nginx.conf
  sudo service nginx restart
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
