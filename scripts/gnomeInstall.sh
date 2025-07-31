#!/bin/bash

sudo pacman -Syu

sudo pacman -S gnome --needed --noconfirm

sudo systemctl enable gdm.service
# ENABLE AUTOLOGIN
# Get your username
clear
echo ""
read -p "Enter The User To Automatically Login Into The Gnome Environment: " USERNAME
ESCAPED_USERNAME=$(printf '%s\n' "$USERNAME" | sed 's/[\/&]/\\&/g')

# Use sudo to insert the lines after [daemon]
sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=$ESCAPED_USERNAME" /etc/gdm/custom.conf

echo "Added automatic login for user: $ESCAPED_USERNAME"

sleep 1
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 1

if [ -f setup.sh ]; then
    # setup.sh exists
    if [ -x setup.sh ]; then
        echo "setup.sh is executable. Running..."
        ./setup.sh --noconfirm
    else
        echo "setup.sh is not executable. Making it executable..."
        chmod +x setup.sh
        echo "Running setup.sh..."
        ./setup.sh --noconfirm
    fi
else
    echo "setup.sh does not exist."
fi

echo "Please reboot"
sudo reboot
