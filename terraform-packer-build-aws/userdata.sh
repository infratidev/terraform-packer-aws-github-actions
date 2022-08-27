#!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  sudo iptables -F
  sudo echo "<h1> Welcome to my terraform => infrati.dev <= WebServer IP: $(curl -s ifconfig.me) </h1>" | sudo tee "/var/www/html/index.html"
  echo "*** Completed Installing apache2"