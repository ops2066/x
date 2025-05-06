#!/bin/bash
cd /opt/dow/
sudo tar -zxvf /opt/dow/app.tar.gz -C /opt/game/api
sudo chown -R www-data:www-data /opt/game
sudo chmod -R 755 /opt/game
sudo chmod +x /opt/game/api/bin/app
timestamp=$(date +"%Y-%m-%d-%H-%M")
src_file="app.tar.gz"
new_file="${timestamp}-${src_file}"
mv "$src_file" "$new_file"
echo "new file name:$new_file"
sudo systemctl restart bot-api.service
sudo systemctl restart bot-admin.service
