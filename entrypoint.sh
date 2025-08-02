#!/bin/bash
set -e

# 1. Prepare D-Bus runtime directory
dbus-uuidgen --ensure

# 2. Launch the system D-Bus daemon in the background
/usr/bin/dbus-daemon --system --fork

# 3. Give D-Bus a moment to settle
sleep 1

# 4. Start oddjobd so it can connect to the now-running bus
/usr/sbin/oddjobd &

# 5. Launch SSSD in the foreground (interactive mode)
/usr/sbin/sssd -i &

# 6. Finally, run SSHD as PID 1 to keep the container alive
exec /usr/sbin/sshd -D

