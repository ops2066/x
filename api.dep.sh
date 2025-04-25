#!/bin/bash
cd /opt/dow/
sudo tar -zxvf /opt/dow/app.tar.gz -C /opt/api
sudo chown -R www-data:www-data /opt/api
timestamp=$(date +"%Y-%m-%d-%H-%M")
src_file="app.tar.gz"
new_file="${timestamp}-${src_file}"
mv "$src_file" "$new_file"
echo "new file name：$new_file"
