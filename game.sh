sudo apt-get update 
sudo apt install apache2 -y
sudo apt-get update
sudo systemctl start apache2 
sudo systemctl enable apache2
git clone https://github.com/gabrielecirulli/2048.git
cp -R 2048/* /var/www/html
