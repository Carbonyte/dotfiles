#!/bin/bash

mkdir -p ~/.local/bin

sudo apt-get update
sudo apt-get -y upgrade
## INSTALL PACKAGES ##
# Install basic utilities
sudo apt-get install -y git wget curl vim stow zip unzip ca-certificates

# Advanced utilities
sudo apt-get install -y fzf apt-file bat ripgrep fd-find eza
ln -s $(which batcat) ~/.local/bin/bat
ln -s $(which fdfind) ~/.local/bin/fd

# Fish shell
sudo apt-get install -y fish
stow fish
sudo usermod --shell /usr/bin/fish $USER

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
stow starship

# C/C++
sudo apt-get install -y gcc clang make cmake

# Node, pnpm
sudo apt-get install -y nodejs
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Lua
sudo apt-get install -y lua5.1 luarocks

# Python
sudo apt-get install -y python3 python3-pip python-is-python3

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Neovim
sudo rm -rf /opt/nvim
curl -L https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz | sudo tar -C /opt -xzf -
ln -s /opt/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
stow nvim

# Docker
#sudo install -m 0755 -d /etc/apt/keyrings
#sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
#sudo chmod a+r /etc/apt/keyrings/docker.asc
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
#  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
