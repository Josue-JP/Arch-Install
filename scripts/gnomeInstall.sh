#!/bin/bash

sudo pacman -Syu

sudo pacman -S gnome --needed --noconfirm

sudo systemctl enable gdm.service
# ENABLE AUTOLOGIN
# Get your username
USERNAME=$(whoami)

# Use sudo to insert the lines after [daemon]
sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=$USERNAME" /etc/gdm/custom.conf

echo "Added automatic login for user: $USERNAME"
if [ -f setup.sh ]; then
    # setup.sh exists
    if [ -x setup.sh ]; then
        echo "setup.sh is executable. Running..."
        ./setup.sh
    else
        echo "setup.sh is not executable. Making it executable..."
        chmod +x setup.sh
        echo "Running setup.sh..."
        ./setup.sh
    fi
else
    echo "setup.sh does not exist."
fi

echo "Please reboot"
sudo reboot
