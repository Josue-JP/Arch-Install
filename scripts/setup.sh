#!/bin/bash


# Define the array of packages
packages=(
    ghostty
    tmux
    vim
    btop
    htop
    git
)

# List all the packages to be installed
echo "The following packages will be installed:"
for pkg in "${packages[@]}"; do
  echo "$pkg"
done

read -p "Press Any Key To Download These Packages" _

# Install packages
for pkg in "${packages[@]}"; do
  echo "Installing $pkg..."
  sudo pacman -S --needed --noconfirm "$pkg"
done

echo "Installation complete"



### === VIM CONFIGURATION === ###
VIMRC="$HOME/.vimrc"
VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"

VIM_SETTINGS=$(cat << 'EOF'
"""""""""""
" vim-plug
"""""""""""
" To vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" To install plugins:
" :PlugInstall
"""""""""""
if &compatible
  set nocompatible               " Be iMproved
endif

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'easymotion/vim-easymotion'

" End vim-plug setup
call plug#end()


" Built-in Plugins
syntax enable
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set scrolloff=7

" Key-binds
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
let mapleader = " "
inoremap <C-BS> <C-W>
nnoremap diw diwx
nmap <leader>f <Plug>(easymotion-bd-w)
nnoremap ;di diwi
nnoremap ;n :bn<CR>


" Snippets
noremap ,cb :-1read ~/snippets/codeBubble.md<CR>ji
EOF
)

# Install vim-plug if needed
if [ ! -f "$VIM_PLUG_PATH" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$VIM_PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo "vim-plug installed!"
else
  echo "vim-plug already installed."
fi

# Append Vim settings if not already present
if ! grep -q "Plug 'easymotion/vim-easymotion'" "$VIMRC"; then
  echo "$VIM_SETTINGS" >> "$VIMRC"
  echo "Appended Vim settings to $VIMRC"
else
  echo "Vim settings already in $VIMRC"
fi

# Install Vim plugins
echo "Installing Vim plugins..."
vim +PlugInstall +qall


### === TMUX CONFIGURATION === ###
TMUX_CONF="$HOME/.tmux.conf"

TMUX_SETTINGS=$(cat << 'EOF'
unbind r
bind r source-file ~/.tmux.conf

set-option -g mode-keys vi

set -g prefix C-s

set -g status-style fg=white,bg=default
set -g status-position top
EOF
)

# Append TMUX settings if not already present
if ! grep -q "set -g prefix C-s" "$TMUX_CONF"; then
  echo "$TMUX_SETTINGS" >> "$TMUX_CONF"
  echo "Appended tmux settings to $TMUX_CONF"
else
  echo "Tmux settings already in $TMUX_CONF"
fi

