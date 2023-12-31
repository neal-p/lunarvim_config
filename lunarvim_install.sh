#!/bin/bash

# LUNAR VIM INSTALL
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

# Make the undodir directory
mkdir -p $HOME/.lvim/undodir/

# Link the config from this repo to lunarvim
ln -s $(pwd)/config.lua $HOME/.config/lvim/config.lua

# FOR CLIPBOARD:
XCLIP=false

# https://stackoverflow.com/questions/34932495/forward-x11-failed-network-error-connection-refused
# need xclip and to follow X11 settings
# from above
# set up Xming

if $XCLIP
    then

    mkdir -p  $HOME/.local/bin
    cd $HOME/.local/bin

    git clone https://github.com/astrand/xclip.git
    cd xclip
    autoreconf
    ./configure --prefix=$HOME/.local --disable-shared
    make
    make install
fi

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit.tar.gz
rm lazygit


