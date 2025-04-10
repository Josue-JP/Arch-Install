#!/bin/bash
# Set timezone
clear
ls /usr/share/zoneinfo/America
echo "Enter your timezone (Example: New_York):"
read timezone
ln -sf /usr/share/zoneinfo/America/$timezone /etc/localtime
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
echo "Set a password for root:"
passwd

# Create daily user
echo "Enter a username for daily use:"
read user
useradd -m -G wheel -s /bin/bash "$user"
echo "Set a password for $user:"
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
lsblk
read -p "Please Re-Enter Your Root Partition/Encrypted Partition. Example: /dev/sdb2
" rootPartition
echo ""
rootUUID=$(blkid -o value -s UUID "$rootPartition")
cryptUUID=$(blkid -o value -s UUID /dev/mapper/Croot)
sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=UUID=$rootUUID:Croot root=UUID=$cryptUUID\"|" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager

echo "To Complete The Installation Please Execute These Commands"
echo "exit"
echo "reboot"




