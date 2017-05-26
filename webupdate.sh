#! /bin/bash

cd /var/www
sudo rm /var/www/html/*
sudo svn checkout https://github.com/ComlOnline/HullfireSwitcher/trunk/html
sudo chown -R www-data: ./html
