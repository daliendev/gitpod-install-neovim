#!/usr/bin/env bash

cd $(mktemp -d)

# Install Neovim
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract >/dev/null
mkdir -p /home/gitpod/.local/bin
ln -s $(pwd)/squashfs-root/AppRun /home/gitpod/.local/bin/nvim

# Clone Neovim configuration 
git clone --depth 1 https://github.com/daliendev/astro-nvim/ /home/gitpod/.config/nvim

# Install necessary LSP and plugins
nvim --headless +Lazy! sync +qall
nvim --headless -c "MasonInstall javascript typescript-language-server" -c "TSInstall javascript typescript" -c "qall"

echo "Neovim setup completed!"
