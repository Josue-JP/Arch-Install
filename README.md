  ARCH-INSTALL
Download Arch on a Bios machine with encryption with this script.
You will have to do some manual configuration first, and then proceed with the script installation, as this first part is a little more personal to your own situation
NOTE: EVERYTHING in this tutorial is needed in order to complete the installation.


███    ███  █████  ███    ██ ██    ██  █████  ██          ███████ ███████  ██████ ████████ ██  ██████  ███    ██ 
████  ████ ██   ██ ████   ██ ██    ██ ██   ██ ██          ██      ██      ██         ██    ██ ██    ██ ████   ██ 
██ ████ ██ ███████ ██ ██  ██ ██    ██ ███████ ██          ███████ █████   ██         ██    ██ ██    ██ ██ ██  ██ 
██  ██  ██ ██   ██ ██  ██ ██ ██    ██ ██   ██ ██               ██ ██      ██         ██    ██ ██    ██ ██  ██ ██ 
██      ██ ██   ██ ██   ████  ██████  ██   ██ ███████     ███████ ███████  ██████    ██    ██  ██████  ██   ████ 
                                                                                                                 
                                                                                                                    

  MANUAL-SECTION
Firstly, set your keylayout. If you have a us keylayout, just copy the following command
# loadkeys us

Next start to connect to wifi with the following command (for more info: https://wiki.archlinux.org/title/Iwd)
# iwctl

Confirm the connection by pinging any website, for ex: 
# ping google.com

Check partitions
# lsblk




