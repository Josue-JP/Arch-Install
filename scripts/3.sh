#!/bin/bash

# Get the current username
USERNAME=$(whoami)

# Print instructions
echo "Please edit the line starting with ExecStart according to the name of your user"
echo ""
echo "EXAMPLE: "
echo "Before: ExecStart=-/sbin/agetty -o '-- \\u' --noreset --noclear - \${TERM}"
echo "After: ExecStart=-/sbin/agetty -a $USERNAME --noreset --noclear - \${TERM}"

# Wait for user to continue
read -p "Press Any Key to Continue"

# Open the file in Vim for editing
sudo vim /lib/systemd/system/getty\@.service

# Inform user about reboot
echo "Your System Will Now Reboot To Confirm 'AUTO-LOGIN'"

# Wait for user to continue before rebooting
read -p "Press Any Key to Continue"
sudo reboot
