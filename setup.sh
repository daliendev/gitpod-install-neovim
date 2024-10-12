#!/usr/bin/env bash

temp_dir=$(mktemp -d) || { echo "Failed to create temp dir"; exit 1; }
cd "$temp_dir"

# Install Neovim only if not installed
if ! command -v nvim &> /dev/null; then
  curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract >/dev/null
  mkdir -p "$HOME/.local/bin"
  ln -s "$(pwd)/squashfs-root/AppRun" "$HOME/.local/bin/nvim"
else
  echo "Neovim already installed!"
fi

# Install latest static tmux
if ! command -v tmux &> /dev/null; then
  sudo curl -L https://github.com/axonasif/build-static-tmux/releases/latest/download/tmux.linux-amd64.stripped -o /usr/bin/tmux
  sudo chmod +x /usr/bin/tmux
else
  echo "tmux already installed!"
fi

# remove any old nvim config
rm -rf ~/.config/nvim
# Clone Neovim configuration 
git clone --depth 1 https://github.com/daliendev/astro-nvim/ "$HOME/.config/nvim"
# Install necessary LSP and plugins
nvim --headless '+Lazy! sync' +qall

# Auto start tmux on SSH or xtermjs
cat >>"$HOME/.bashrc" <<'EOF'
if test ! -v TMUX && (test -v SSH_CONNECTION || test "$PPID" == "$(pgrep -f '/ide/xterm/bin/node /ide/xterm/index.cjs' | head -n1)"); then
  if ! tmux has-session 2>/dev/null; then
    # Create a new detached tmux session named "gitpod"
    tmux new-session -d -s gitpod -n "editor"
  fi
  exec tmux attach
fi
EOF

# Download Gitpod Tmux Configuration
curl -L "https://raw.githubusercontent.com/daliendev/gitpod.tmux/refs/heads/main/gitpod.tmux" --output ~/gitpod.tmux
chmod +x ~/gitpod.tmux
! grep -q 'gitpod.tmux' ~/.tmux.conf 2>/dev/null && echo "run-shell -b 'exec ~/gitpod.tmux'" >>~/.tmux.conf
