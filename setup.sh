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

# Install latest static tmux
sudo curl -L https://github.com/axonasif/build-static-tmux/releases/latest/download/tmux.linux-amd64.stripped -o /usr/bin/tmux
sudo chmod +x /usr/bin/tmux

# Auto start tmux on SSH or xtermjs
cat >>"$HOME/.bashrc" <<'EOF'
if test ! -v TMUX && (test -v SSH_CONNECTION || test "$PPID" == "$(pgrep -f '/ide/xterm/bin/node /ide/xterm/index.cjs' | head -n1)"); then {
  if ! tmux has-session 2>/dev/null; then {
    tmux new-session -n "editor" -ds "gitpod"
  } fi
    exec tmux attach
} fi
EOF

curl -L "https://raw.githubusercontent.com/axonasif/gitpod.tmux/main/gitpod.tmux" --output ~/gitpod.tmux
chmod +x ~/gitpod.tmux
! grep -q 'gitpod.tmux' ~/.tmux.conf 2>/dev/null && echo "run-shell -b 'exec ~/gitpod.tmux'" >>~/.tmux.conf

echo "tmux setup completed!"
