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

# KDE global-shortcut launchers
for f in /usr/share/applications/com.andresbott.candy.snapscreen-selection.desktop \
         /usr/share/applications/com.andresbott.candy.snapscreen-window.desktop; do
  chown root:root "$f"
  chmod 644 "$f"
done

# refresh the desktop database so KDE picks up the new launchers (best effort)
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
