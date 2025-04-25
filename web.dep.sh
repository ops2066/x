#!/bin/bash
sudo tar -zxvf /opt/dow/build.tar.gz -C /opt/www/web
cd /opt/www/web
sudo pnpm install 
sudo chown -R www-data:www-data /opt/www
sudo chmod -R 755 /opt/www
sudo pm2 reload ecosystem.config.js

cd /opt/dow/
timestamp=$(date +"%Y-%m-%d-%H-%M")
src_file="build.tar.gz"
new_file="${timestamp}-${src_file}"
mv "$src_file" "$new_file"
