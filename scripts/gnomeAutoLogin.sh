#!/bin/bash

# Get your username
USERNAME=$(whoami)

# Use sudo to insert the lines after [daemon]
sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=$USERNAME" /etc/gdm/custom.conf

echo "Added automatic login for user: $USERNAME"

