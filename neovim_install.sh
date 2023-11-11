#!/bin/bash

dir="$HOME/bin"
nvimurl=https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz

cd $dir
wget $nvimurl
tar xzvf nvim-linux64.tar.gz
ln -s ~/bin/nvim-linux64/bin/nvim ~/.local/bin/nvim
