#! /bin/bash

sudo apt update

sudo apt install nginx -y

sudo ufw enable -y

sudo ufw allow 'Nginx FULL'

