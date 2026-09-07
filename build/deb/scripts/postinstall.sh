#!/bin/sh
# postinstall  script

# candy executable
chown root:root /usr/local/bin/candy
chmod 755 /usr/local/bin/candy

# bash completion
chown root:root /usr/share/bash-completion/completions/candy
chmod 644 /usr/share/bash-completion/completions/candy

# snapscreen assets
chown root:root /usr/local/share/snapscreen/shutter.wav
chmod 644 /usr/local/share/snapscreen/shutter.wav

chown root:root /etc/snapscreen.conf
chmod 644 /etc/snapscreen.conf
