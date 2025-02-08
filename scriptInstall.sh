#!/bin/bash
# Arch Linux Installation Script with Encryption & Dual Boot Support
# This Script is free to use
# In this script there will be made three partitions, a boot partition, an encrypted root partition where the OS will be installed, and a swap partition for virtual RAM. 
# The reason as to why someone would like an encrypted arch setup is because if someone steals your usb, hard drive, or whatever your os is loaded to, they won't be able to see all the files because it's encrypted.

# Load US keyboard layout
loadkeys us

# List block devices
lsblk
sleep 3

# Create partitions
while true; do
  echo "----------------------------------------"
  echo "|  Create:                             |"
  echo "|  EFI  -- 1G   Type: EFI System       |"
  echo "|  ROOT - 30G+ Type: Linux Filesystem  |"
  echo "|  SWAP -- 8G+  Type: Linux Swap       |"
  echo "----------------------------------------"
  echo "Press any key to continue..."
  read -n 1 -s 
  echo "Proceeding..."

  echo "Enter the drive you want to write to (example: /dev/sda):"
  read drive

  echo "Confirm selection: '$drive' [y/n]"
  read confirmation

  case "$confirmation" in
    [yY] | "" ) 
      echo "Creating partitions on $drive..."
      cfdisk "$drive"
      break
      ;;
    [nN] )  
      echo "You have chosen not to proceed."
      ;;
    * )  
      echo "Choose a valid option [y/n]..."
      ;;
  esac
done

lsblk
sleep 3

while true; do
  echo "Enter your Boot Partition (example: /dev/sda1):"
  read bootPartition
  echo "Enter your Root Partition (example: /dev/sda2):"
  read rootPartition
  echo "Enter your Swap Partition (example: /dev/sda3):"
  read swapPartition

  echo "Are these correct?"
  echo "Boot: $bootPartition | Root: $rootPartition | Swap: $swapPartition"
  read -p "[y/n] " answer

  case "$answer" in 
    [yY] | "" ) 
      echo "Formatting partitions..."
      mkfs.fat -F32 "$bootPartition"
      cryptsetup luksFormat "$rootPartition"
      cryptsetup open "$rootPartition" Croot
      mkfs.ext4 /dev/mapper/Croot
      mkswap "$swapPartition"
      break
      ;;
    [nN] )  
      echo "Please retry."
      ;;
    * )  
      echo "Choose a valid option [y/n]..."
  esac 
done

# Mount partitions
echo "---------------------------------"
mount /dev/mapper/Croot /mnt
mkdir -p /mnt/boot
mount "$bootPartition" /mnt/boot
swapon "$swapPartition"

# Enable parallel downloads 
echo "---------------------------------"
numOfCores=$(nproc)
echo "Number of Cores: $numOfCores"
echo "How many parallel downloads would you like? (default: 5)"
read -p "[Press Enter to use default]" N

if [[ -z "$N" ]]; then
  N=5
fi

sed -i "s/#ParallelDownloads = 5/ParallelDownloads = $N/" /etc/pacman.conf

# Install base packages
while true; do
  echo "Checking CPU vendor..."
  grep -i 'vendor_id' /proc/cpuinfo
  echo "What is your CPU firmware based on?"
  echo "[1] AMD  |  [2] INTEL"
  read cpu_choice

  case "$cpu_choice" in 
    1 ) 
      pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware amd-ucode sudo git neofetch vim
      break
      ;;
    2 ) 
      pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware intel-ucode sudo git neofetch vim
      break
      ;;
    * )  
      echo "Choose a valid option [1/2]..."
      ;;
  esac 
done

# Generate fstab file
genfstab -U /mnt > /mnt/etc/fstab

# Prompt for timezone & hostname before chroot
echo "Enter your timezone (Example: America/New_York):"
read timezone
echo "Enter a hostname for this system:"
read hostname

# Get UUIDs **before** entering chroot
rootUUID=$(blkid -o value -s UUID "$rootPartition")
cryptUUID=$(blkid -o value -s UUID /dev/mapper/Croot)

# Enter Arch chroot
arch-chroot /mnt /bin/bash <<EOF
# Set timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

# Set locale
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "$hostname" > /etc/hostname

# Set root password
echo "Set a password for root:"
passwd

# Create daily user
echo "Enter a username for daily use:"
read user
useradd -m -G wheel -s /bin/bash "\$user"
echo "Set a password for \$user:"
passwd "\$user"

# Enable sudo for wheel group
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Configure initramfs
sed -i 's/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Automatically configure GRUB with encrypted partitions
sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet cryptdevice=UUID=$cryptUUID:Croot root=UUID=$rootUUID\"|" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager
systemctl enable bluetooth

echo "Setup complete! Exiting chroot..."
exit
EOF

# Unmount partitions and shut down
umount -lR /mnt
shutdown now

