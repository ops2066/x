#!/bin/bash
cd /opt/dow/
sudo tar -zxvf /opt/dow/app.tar.gz -C /opt/api
sudo chown -R www-data:www-data /opt/api
sudo chmod -R 755 /opt/api
sudo chmod +x /opt/api/bin/app
timestamp=$(date +"%Y-%m-%d-%H-%M")
src_file="app.tar.gz"
new_file="${timestamp}-${src_file}"
mv "$src_file" "$new_file"
echo "new file name：$new_file"
sudo systemctl restart tv-api.service
sudo systemctl status tv-api.service
sudo systemctl restart tv-admin.service
sudo systemctl status tv-admin.service
