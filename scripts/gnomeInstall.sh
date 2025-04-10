#!/bin/bash

sudo pacman -Syu

sudo pacman -S gnome --needed --noconfirm

sudo systemctl enable gdm.service
echo "Please reboot after entering the Gnome Environment"
read -p "Press any key to continue"
sudo systemctl start gdm.service

# ENABLE AUTOLOGIN
# Get your username
USERNAME=$(whoami)

# Use sudo to insert the lines after [daemon]
sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=$USERNAME" /etc/gdm/custom.conf

echo "Added automatic login for user: $USERNAME"

