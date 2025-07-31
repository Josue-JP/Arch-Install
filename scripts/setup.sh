#!/bin/bash

NOCONFIRM=false

if [[ "$1" == "--noconfirm" ]]; then
    NOCONFIRM=true
fi

set -e

echo "!!!DISCLAIMER!!!"
echo "BEFORE CONTINUING BE AWARE THAT THIS SCRIPT IS MEANT TO ONLY BE RAN ON A BRAND NEW SYSTEM, NOT ON A SYSTEM THAT ALREADY HAS CONFIG FILES"
echo "PLEASE DO NOT RUN THIS SCRIPT MORE THAN ONCE"

if ! $NOCONFIRM; then
    read -p "Enter 'UNDERSTAND' if you understand what this means" userInput

    if [[ "$userInput" != "UNDERSTAND" ]]; then
        echo "ABORTING SCRIPT"
        echo "You must type 'UNDERSTAND' to proceed"
        exit 1
    fi

fi



# Define the array of packages
packages=(
    ghostty
    tmux
    vim
    btop
    htop
    git
    python3
)

# List all the packages to be installed
echo "The following packages will be installed:"
for pkg in "${packages[@]}"; do
  echo "$pkg"
done
echo "yay"
echo "Brave-Browser"



read -p "Press Enter To Download These Packages" _

# Install packages
for pkg in "${packages[@]}"; do
  echo "Installing $pkg..."
  sudo pacman -S --needed --noconfirm "$pkg"
done

sudo pacman -S --noconfirm --needed base-devel git

cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay

makepkg -si --noconfirm

echo "Installing Brave Browser (brave-bin)..."
yay -S --noconfirm brave-bin

echo "Installation complete"


echo "CREATING/APPENDING TO ~/.vimrc, ~/.bashrc, and ~/.tmux.conf"

DUMP_REPO="https://github.com/Josue-JP/Dump"
git clone $DUMP_REPO

cd Dump/home

bashrc=$(python3 script.py bashrc)
vimrc=$(python3 script.py vimrc)
tmuxconf=$(python3 script.py tmux.conf)

cd -

rm -rf Dump

# Variables
VIMRC="$HOME/.vimrc"
VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"
TMUX_CONF="$HOME/.tmux.conf"
BASH_RC="$HOME/.bashrc"



# Use the variables
printf '%s\n' "$bashrc" >> $BASH_RC
printf '%s\n' "$vimrc" >> $VIMRC
printf '%s\n' "$tmuxconf" >> $TMUX_CONF


# Install vim-plug if needed
if [ ! -f "$VIM_PLUG_PATH" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$VIM_PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo "vim-plug installed!"
fi


# Install Vim plugins
echo "Installing Vim plugins..."
vim +PlugInstall +qall

