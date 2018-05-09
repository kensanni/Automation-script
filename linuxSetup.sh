installNginx() {
  sudo yum install nginx -y
}


setupSSLCertificate() {
  read -p "Your domain name in these format 'example.com' for SSL certificate: " domain
  printf '====================================== Setting up SSL certificate ======================================= \n'
  cd ../
  git clone https://github.com/letsencrypt/letsencrypt
  cd letsencrypt/
  service nginx stop
  ./letsencrypt-auto certonly --debug --standalone -d "$domain"
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
