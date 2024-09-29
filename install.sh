#!/usr/bin/env bash

cd $(mktemp -d)

# Install dependencies
apt-get update
apt-get install -y build-essential curl git

# Install Nerd Fonts (FiraCode as an example)
mkdir -p ~/.local/share/fonts
curl -fLo "~/.local/share/fonts/0xProto Nerd Font.ttf" \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip
fc-cache -fv

# Install Neovim
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract >/dev/null
mkdir -p /home/gitpod/.local/bin
ln -s $(pwd)/squashfs-root/AppRun /home/gitpod/.local/bin/nvim

# Clone Neovim configuration 
git clone --depth 1 https://github.com/daliendev/astro-nvim/ ~/.config/nvim

# Install necessary LSP and plugins
nvim --headless +Lazy! sync +qall
nvim --headless -c "MasonInstall javascript typescript-language-server" -c "TSInstall javascript typescript" -c "qall"

echo "Neovim setup completed!"