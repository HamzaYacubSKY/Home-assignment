#! /bin/bash

##### ANSIBLE #####

sudo apt update

sudo apt install ansible -y

##### NGINX #####

sudo apt update

sudo apt install nginx -y

sudo ufw enable -y

sudo ufw allow 'Nginx FULL'