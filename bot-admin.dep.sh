#!/bin/bash
sudo tar -zxvf /opt/dow/dist.tar.gz -C /opt/game/admin
sudo chown -R www-data:www-data /opt/game
sudo chmod -R 755 /opt/game
sudo rm -rf /opt/dow/dist.tar.gz
