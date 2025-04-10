#!/bin/bash
echo "Please edit the line starting with ExecStart according to the name of your user"
echo "EXAMPLE: "
echo ""
echo "Before: ExecStart=-/sbin/agetty -o '-- \\u' --noreset --noclear - \${TERM}"
echo "After: ExecStart=-/sbin/agetty -a \$user --noreset --noclear - \${TERM}"
read -p "Press Any Key to Continue"
sudo vim /lib/systemd/system/getty\@.service
echo "Your System Will Now Reboot To Confirm 'AUTO-LOGIN'" 
read -p "Press Any Key to Continue"
sudo reboot
