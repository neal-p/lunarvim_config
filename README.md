# Install scripts and configuration for my LunarVim setup

## Neovim install from source
`bash neovim_install.sh` will check out stable version of neovim source and install at `$HOME/.local/bin/nvim`

## LunarVim install and setup
`bash lunarvim_install.sh` will download and run the lunarvim install script, copy the provided `config.lua` to the proper location, create the lvum undodir, and install `xclip` from source for clipboard support.
Note! If using via ssh, then will need an X11 app to forward the clipboard. So on windows get Xming, on Mac would need XQuarts.

## packages that need to be present
These are typical for linux and all were already present on the HPC systems I've used
But, if you are installing in fresh WSL, you likely will have to install them

  - build-essential
  - autoconf
  - npm
  - libxmu-dev
  - unzip

## LSP Support
Once everything is set up, need to open `lvim`, type `:Mason` to open the Mason LSP package manager, and install

```console
  Installed ◍ bash-language-server bashls
    ◍ black 
    ◍ clang-format 
    ◍ clangd 
    ◍ cpplint 
    ◍ flake8 
    ◍ lua-language-server lua_ls
    ◍ pyright 
    ◍ yaml-language-server yamlls
``` 


