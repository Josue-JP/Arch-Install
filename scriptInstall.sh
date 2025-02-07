#!/bin/bash
# This Script is free to use
# In this script there will be made three partitions, a boot partition, an encrypted root partition where the OS will be installed, and a swap partition for virtual RAM. 
# The reason as to why someone would like an encrypted arch setup is because if someone steals your usb, hard drive, or whatever your os is loaded to, they won't be able to see all the files because it's encrypted.
# Load US keyboard layout
loadkeys us

# List block devices
lsblk
sleep 3

# Create partitions
echo "---------------------------------"
while true; do
  echo "----------------------------------------"
  echo "|                                      |"
  echo "|  Create:                             |"
  echo "|  EFI  -- 1G   Type: EFI System       |"
  echo "|  ROOT - 30G+ Type: Linux Filesystem  |"
  echo "|  SWAP -- 8G+  Type: Linux Swap       |"
  echo "|                                      |"
  echo "----------------------------------------"
  echo "Press any key to continue"
  read -n 1 -s 
  echo "Proceeding..."
  

  echo "Enter the drive you want to write to (example: /dev/sda):"
  read drive

  echo "
  Confirm that what you  have selected is correct: '$drive'"
  read confirmation

  case "$confirmation" in
    [yY] | "" )
      echo "Creating partitions on $drive..."
      sudo cfdisk $drive
      break
      ;;
    [Nn] )  # Matches 'n' or 'N'
      echo "You have chosen not to proceed"
      break
      ;;
    * )
      echo "Choose a valid option [y/n]..."
      ;;
  esac
done

lsblk
sleep 3

while true; do
  echo "Example: /dev/sda1"
  echo "Enter your Boot Partition partition" 
  read bootPartition
  echo ""
  echo "Example: /dev/sda2"
  echo "Enter your Root Partition partition" 
  read rootPartition
  echo ""
  echo "Example: /dev/sda3"
  echo "Enter your Swap Partition partition" 
  read swapPartition
  echo ""
  echo "Are these correct?"
  echo "Boot Partition: $bootPartition"
  echo "Root Partition: $rootPartition"
  echo "Swap Partition: $swapPartition"
  read Answer

  case $Answer in 
    y|Y|"" ) 
      echo "Formating partitions..."
      mkfs.fat -F32 $bootPartition
      cryptsetup luksFormat $rootPartition
      cryptsetup open $rootPartition Croot
      mkfs.ext4 /dev/mapper/Croot
      mkswap $swapPartition
      break
      ;;
    n|N ) 
      echo "Please retry"
      ;;
    * )  
    echo "Choose a valid option [y/n]..."
  esac 
done

# Mount partitions
echo "---------------------------------"
mount /dev/mapper/Croot /mnt
mkdir -p /mnt/boot
mount $bootPartition /mnt/boot
swapon $swapPartition

# Enable parallel downloads 
echo "---------------------------------"
# Gets the processors and cores of the current device, and displays them
numOfProcessors=$(grep -c processor /proc/cpuinfo)
numOfCores=$(nproc)
echo "Number of Processors: $numOfProcessors"
echo "Number of Cores: $numOfCores"

# Allows ParalledDownloads according to the input
echo "How many parallel downloads would you like?" 
read N 
sudo sed -i "s/#ParallelDownloads = 5/ParallelDownloads = $N/" /etc/pacman.conf

# Install base packages
while true; do
  # Check CPU vendor
  echo "Checking CPU vendor..."
  grep -i 'vendor_id' /proc/cpuinfo
  lscpu | grep Vendor
  echo "What is your CPU firmware based on"
  echo "[1]AMD [2]INTEL"
  echo "Enter a number"
  read number

  case $number in 
    1 ) 
      echo ""
      echo "Installing base packages..."
      pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware amd-ucode sudo git neofetch vim
      break
      ;;
    2 ) 
      echo ""
      echo "Installing base packages..."
      pacstrap /mnt base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware intel-ucode sudo git neofetch vim
      break
      ;;
    * )  
      echo "Choose a valid option [1/2]..."
      ;;
  esac 
done

# Generate fstab file
echo "Generating fstab file..."
genfstab -U /mnt > /mnt/etc/fstab

# Enter Arch chroot HERE
echo "Entering Arch chroot..."
arch-chroot /mnt /bin/bash <<EOF
# Place chroot-specific commands here
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$hostname" > /etc/hostname

# Set timezone and clock
echo "Setting timezone and clock..."
ls /usr/share/zoneinfo
echo "Please make sure to check through all directorys to find a specific timezone"
echo "What is your timezone? (Example: America/New_York)"
read timezone

if [ -e /usr/share/zoneinfo/$timezone ]; then
  ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
else
  echo "INVALID TIMEZONE"
fi
hwclock --systohc
date
sleep 3

# Set locale
echo "Setting locale..."
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "Enter a custom hostname"
read hostname
echo "$hostname" | sudo tee /etc/hostname

# Set passwords
echo "Setting passwords..."
echo "Enter a password for the rootuser"
passwd
echo "You will now add a daily user that has elevated privileges"
sleep 3

echo "Enabling wheel group for sudo"
if ! sudo grep -qE '^\s*%wheel\s+ALL=\(ALL(:ALL)?\)\s+ALL' /etc/sudoers; then
  echo "Enabling sudo for wheel group..."
  sudo sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
else
  echo "Wheel group already enabled for sudo."
fi

echo "Enter your daily user"
read user
useradd -m -G wheel -s /bin/bash $user
passwd $user

# Configure initcpio and Grub 
echo "Configuring initcpio and Grub..."
sed -i 's/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf
if mkinitcpio -P; then
  echo "Initramfs updated successfully."
else
  echo "Failed to update initramfs."
fi

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

echo "Please go to the bottom of the file that will be edited"
sleep 3
echo "---------------------------------"| sudo tee -a /etc/default/grub
blkid -o value -s UUID /dev/sdb4 >> /etc/default/grub
blkid -o value -s UUID /dev/mapper/Croot >> /etc/default/grub
echo "---------------------------------"| sudo tee -a /etc/default/grub

echo ""
echo '# Copy the two UUIDs to the top of the file, after the word "quiet".' | sudo tee -a /etc/default/grub
echo '# Example:' | sudo tee -a /etc/default/grub
echo '# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=<your-crypt-uuid>:Croot root=UUID=<your-root-uuid>"' | sudo tee -a /etc/default/grub
echo '# Make sure everything is in one line, and remember that Linux is case-sensitive.' | sudo tee -a /etc/default/grub

vim /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
echo "Enabling services..."
systemctl enable NetworkManager
systemctl enable bluetooth

# Exit and shutdown
echo "Thank you for using this script"
echo "Exiting and shutting down..."
sleep 3
exit
EOF
umount -lR /mnt
shutdown now


