#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo chmod a+wr /usr/share/nginx/html/index.html
echo "Hello from `hostname`" > /usr/share/nginx/html/index.html