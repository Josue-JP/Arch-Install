# Arch Linux Installation Guide

This guide walks you through installing Arch Linux using custom scripts from a USB drive. Follow these steps carefully to set up your system with the GNOME desktop environment.

## Prerequisites
- A USB drive with the Arch Linux ISO.
- A computer with internet access.
- Basic familiarity with terminal commands.

## Installation Steps

1. **Boot from USB**
   Insert the USB with the Arch Linux ISO and set it as the boot priority in your BIOS/UEFI settings.

2. **Connect to Wi-Fi**
   Use the `iwctl` command to connect to a Wi-Fi network.
   For details, see the [Arch Wiki: iwd](https://wiki.archlinux.org/title/Iwd).
   ```bash
   iwctl
   ```

3. **Update Keyring and Install Git**
   Run these commands to ensure you have the latest keyring and Git installed:
   ```bash
   pacman -Sy archlinux-keyring
   pacman -S git
   ```

4. **Clone the Repository**
   Clone the installation scripts from GitHub:
   ```bash
   git clone https://github.com/Josue-JP/Arch-Install
   ```

5. **Navigate to Scripts Directory**
   Move into the scripts folder:
   ```bash
   cd Arch-Install/scripts
   ```

6. **Run the First Script**
   Execute the first script and follow its prompts:
   ```bash
   ./1.sh
   ```

7. **Enter Chroot Environment**
   After the first script completes, enter the chroot environment:
   ```bash
   arch-chroot /mnt /bin/bash
   ```
-------

8. **Run the Second Script**
   Execute the second script and follow its instructions:
   ```bash
   ./2.sh
   ```


9. **Reboot and Log In**
    After the second script finishes, reboot your system. Log in using the password set during the first script.

-------

10. **Connect to Wi-Fi Post-Install**
    Use `nmcli` to connect to Wi-Fi. Replace `YourSSID` with your network name:
    ```bash
    nmcli --ask device wifi connect "YourSSID"
    ```
    For details, see the [Arch Wiki: NetworkManager](https://wiki.archlinux.org/title/NetworkManager).

11. **Navigate to Root Directory**
    Move to the root directory:
    ```bash
    cd /
    ```

12. **Install GNOME Environment**
    Run the GNOME installation script:
    ```bash
    ./gnomeInstall.sh
    ```

13. **Customize Packages (Optional)**
    The `gnomeInstall.sh` script downloads default packages. To install different packages, edit the `setup.sh` file before running the script.

## Notes
- Ensure a stable internet connection during the process.
- Follow each script’s on-screen instructions carefully.
- If you encounter issues, refer to the [Arch Linux Wiki](https://wikilyrics.org/) for troubleshooting.

Happy installing!
