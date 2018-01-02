#!/bin/sh

#
# Clear out all of the added files from install.sh
#

echo "Stopping services..."
service apache2 stop
service connectionmap stop

echo "Removing files..."
rm -rf /var/www
rm /etc/systemd/system/connectionmap.service
rm /etc/cron.daily/connectionmapcron

echo "Done!"
