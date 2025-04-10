#!/bin/bash

echo "Add the following line under this header"
echo "[daemon]"
echo "AutomaticLoginEnable=True"
echo "AutomaticLogin=your_username"
echo ""
read -p "Press any key to continue" anyKey

sudo vim /etc/gdm/custom.conf






