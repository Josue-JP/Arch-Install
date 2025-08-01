#!/bin/bash
# Set timezone
clear
ls /usr/share/zoneinfo/America
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Set locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "Enter a hostname for this system:"
read hostname
echo "$hostname" > /etc/hostname

# Set root password
echo "This Password Will Be For Root:"
passwd

# Create daily user
read -p "Enter a username for daily use:" user

useradd -m -G wheel -s /bin/bash "$user"
echo "This Password Will Be For The User $user:"
passwd "$user"

# Enable sudo for wheel group
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Configure initramfs
sed -i 's/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Automatically configure GRUB with encrypted partitions
clear

rootUUID=$(blkid -o value -s UUID "$rootPartition")
cryptUUID=$(blkid -o value -s UUID /dev/mapper/Croot)
sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=UUID=$rootUUID:Croot root=UUID=$cryptUUID\"|" /etc/default/grub
if grep -q "^\s*#\?\s*GRUB_DISABLE_OS_PROBER=" /etc/default/grub; then
    # Uncomment and replace the line
    sed -i 's|^\s*#\?\s*GRUB_DISABLE_OS_PROBER=.*|GRUB_DISABLE_OS_PROBER=false|' /etc/default/grub
else
    # Append it if not found
    echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
fi

sleep 1

sudo grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager

# Get the current username
echo ""
ESCAPED_USERNAME=$(printf '%s\n' "$user" | sed 's/[\/&]/\\&/g')

# Enable auto-login into the current user
sudo sed -i "s|^ExecStart=-/sbin/agetty .*|ExecStart=-/sbin/agetty -a $ESCAPED_USERNAME --noreset --noclear - \${TERM}|" /lib/systemd/system/getty@.service

sleep 1

# This sends variables into gnomeInstall.sh
VAR_NAME1="ESCAPED_USERNAME"
TARGET="gnomeInstall.sh"

# Insert the variable assignment after the shebang line
{
  head -n 1 "$TARGET" # Print first line (shebang)
  echo "$VAR_NAME1=\"$ESCAPED_USERNAME\""   # Print the variables
  tail -n +2 "$TARGET" # Print the rest of the file starting from line 2
} > temp_file && mv temp_file "$TARGET"




sleep 1
clear

echo "To Complete The Installation Please Execute These Commands"
ecoh ""
echo "- exit"
echo "- umount -lR /mnt"
echo "- shutdown now"
echo ""
echo "NOTE: While the competer is shutdown, please eject the flash-drive from your Computer. After ejecting the usb-stick, then turn your Computer back on"
echo "After ejecting the USB-stick and turning on your computer, you can now choose which desktop environment or window manager you want."
