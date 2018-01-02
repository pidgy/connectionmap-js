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

echo "installing dependencies..."
apt-get install python2.7
pip install netaddr
pip install psutil
apt-get install apache2
apt-get install tcpdump

echo "Setting up service and cron job files..."
cp connectionmap.service /etc/systemd/system/
cp connectionmapcron /etc/cron.hourly/

chmod -R 666 www/
rm -rf /var/www
cp -r www/ /var/

echo "Starting Apache server..."
systemctl daemon-reload
service apache2 stop
service apache2 start

echo "Running connectionmap-js..."
service connectionmap start

echo "Finished! Browse to http://"`hostname`
