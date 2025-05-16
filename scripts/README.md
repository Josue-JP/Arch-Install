Arch Linux Installation Guide
This guide walks you through installing Arch Linux using custom scripts from a USB drive. Follow these steps carefully to set up your system with the GNOME desktop environment.
Prerequisites

A USB drive with the Arch Linux ISO.
A computer with internet access.
Basic familiarity with terminal commands.

Installation Steps

Boot from USBInsert the USB with the Arch Linux ISO and set it as the boot priority in your BIOS/UEFI settings.

Connect to Wi-FiUse the iwctl command to connect to a Wi-Fi network.For details, see the Arch Wiki: iwd.  
iwctl


Update Keyring and Install GitRun these commands to ensure you have the latest keyring and Git installed:  
pacman -Sy archlinux-keyring
pacman -S git


Clone the RepositoryClone the installation scripts from GitHub:  
git clone https://github.com/Josue-JP/Arch-Install


Navigate to Scripts DirectoryMove into the scripts folder:  
cd Arch-Install/scripts


Make Script ExecutableGrant executable permissions to the first script:  
chmod +x 1.sh


Run the First ScriptExecute the first script and follow its prompts:  
./1.sh


Enter Chroot EnvironmentAfter the first script completes, enter the chroot environment:  
arch-chroot /mnt /bin/bash


Run the Second ScriptExecute the second script and follow its instructions:  
./2.sh


Reboot and Log InAfter the second script finishes, reboot your system. Log in using the password set during the first script.

Connect to Wi-Fi Post-InstallUse nmcli to connect to Wi-Fi. Replace YourSSID with your network name:  
nmcli --ask device wifi connect "YourSSID"

For details, see the Arch Wiki: NetworkManager.

Navigate to Root DirectoryMove to the root directory:  
cd /


Install GNOME EnvironmentRun the GNOME installation script:  
./gnomeInstall.sh


Customize Packages (Optional)The gnomeInstall.sh script downloads default packages. To install different packages, edit the setup.sh file before running the script.


Notes

Ensure a stable internet connection during the process.
Follow each script’s on-screen instructions carefully.
If you encounter issues, refer to the Arch Linux Wiki for troubleshooting.

Happy installing!
