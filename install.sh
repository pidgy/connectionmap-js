#!/bin/sh

echo " |------------------------------------------------------------------|"
echo " |                                                                  |"
echo " |                           Connection Map                         |"
echo " |                                                                  |"
echo " |                    \"Where's your traffic going?\"                 |"
echo " |                                                                  |"
echo " |------------------------------------------------------------------|"
echo "                ,_   .  ._. _.  ."
echo "            , _-\,|~\~      ~/      ;-_   _-     ,;_;_,    ~~-"
echo "   /~~-\_/-~-- \~~| ,    ,      /  / ~|-_\_/~/~      ~~--~~~~--_"
echo "   /              ,/-/~ \ , _  , |,|~                   ._/-, /~"
echo "   ~/-~\_,       -,| |.    ~  ,\ /~                /    /_  /~"
echo " .-~      |        ,\~|\       _\~     ,_  ,               /|"
echo "           \        /~          |_/~\\,-,~  \          ,_,/ |"
echo "            |       /            ._-~\_ _~|               \  / "
echo "             \   __-\           /      ~ |\  \_          /  ~"
echo "   .,         \ |,  ~-_      - |          \\_ ~|  /\  \~ ,"
echo "                ~-_  _;       \           -,   \, /\/  |"
echo "                  \_,~\_       \_ _,       /      |, /|"
echo "                    /     \_       ~ |      /         \  ~; -,_."
echo "                    |       ~\        |    |  ,        -_, ,; ~ ~\ "
echo "                     \,      /        \    / /|            ,-, ,   -,"
echo "                      |    ,/          |  | |/          ,-   ~ \   ."
echo "                     ,|   ,/           \ ,/              \       |"
echo "                     /    |             ~                 -~~-, /   _"
echo "                     |  ,-                                    ~    /"
echo "                     / ,                                      ~"
echo "                     ,|  ~"
echo "                       ~"
echo "by: trashbo4t"
echo ""

echo "Dependencies required:"
echo "python2.7"
echo "|"
echo "|__netaddr"
echo "|__psutil"
echo ""
echo "apache"
echo ""
echo "tcpdump"
echo ""
echo "Do you wish to install dependencies [Y/n]?" && read yesno

if [ "$yesno" = "Y" ]; then
	echo "installing dependencies..."
	apt-get install python2.7
	pip install netaddr
	pip install psutil
	apt-get install apache2
	apt-get install tcpdump
fi

echo "Enter your Google Maps Javascript API Key: " 
read APIKEY
sed -i '1s/.*/var apiKey="'"$APIKEY"'";/g' www/html/js/script.js

echo "Setting up service and cron job files..."
cp connectionmap.service /etc/systemd/system/
cp connectionmapcron /etc/cron.daily/

rm -rf /var/www
cp -r www/ /var/

echo "Starting Apache server..."
systemctl daemon-reload
service apache2 stop
service apache2 start

echo "Running connectionmap-js..."
service connectionmap start

chmod -R 777 /var/www

echo "Finished! Browse to http://"`hostname`
