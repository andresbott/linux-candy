#!/bin/sh
# postinstall  script
#
# snapscreen
chown root:root  /usr/local/share/snapscreen/shutter.wav
chmod 644  /usr/local/share/snapscreen/shutter.wav

chown root:root /usr/local/bin/snapscreen
chmod 755 /usr/local/bin/snapscreen

chown root:root /etc/snapscreen.conf
chmod 644 /etc/snapscreen.conf
# public ip

chown root:root /usr/local/bin/public-ip
chmod 755 /usr/local/bin/public-ip