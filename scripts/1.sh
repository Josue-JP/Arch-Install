#!/bin/bash
# Arch Linux Installation Script with Encryption & Dual Boot Support
# This Script is free to use
# In this script there will be made three partitions, a boot partition, an encrypted root partition where the OS will be installed, and a swap partition for virtual RAM.
# The reason as to why someone would like an encrypted arch setup is because if someone steals your usb, hard drive, or whatever your os is loaded to, they won't be able to see all the files because it's encrypted.

# Load US keyboard layout
loadkeys us

# Make files executable
files=(
    2.sh
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        chmod +x "$file"
        echo "$file is now executable."
    else
        echo "$file does not exist."
    fi
done


# Create partitions
while true; do
  clear
  # List block devices
  lsblk
  echo "----------------------------------------"
  echo "|  Create The Following Partitions:    |"
  echo ""
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

sleep 1

while true; do
  clear
  lsblk
  sleep 3
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
      echo "This Will Serve As The Password To Enter Your Encrypted Device"
      until cryptsetup luksFormat "$rootPartition"; do
        echo "luksFormat failed. Retrying..."
        sleep 1  # If failed to create password it retry's 
      done


      cryptsetup luksFormat "$rootPartition"
      echo "Enter The Password That You Just Made"
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
mkdir /mnt/boot
mount "$bootPartition" /mnt/boot
swapon "$swapPartition"

# Enable parallel downloads
echo "---------------------------------"

sed -i "s/#ParallelDownloads = 5/ParallelDownloads = 5/" /etc/pacman.conf

# Install base packages
clear
pacstrap /mnt --needed --noconfirm base base-devel networkmanager lvm2 cryptsetup grub efibootmgr linux linux-firmware git neofetch vim
break

# Generate fstab file
genfstab -U /mnt > /mnt/etc/fstab

# Send the 2nd file into /mnt
cp 2.sh /mnt

clear
echo ""
echo "To Complete The Installation Please Execute The Following Command:"
echo "arch-chroot /mnt /bin/bash"
echo ""
echo "After Executing That Command Please Run The Second Script Which Is '2.sh'"
echo ""



