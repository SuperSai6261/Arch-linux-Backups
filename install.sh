#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
echo "Installing dotfiles from $DOTFILES..."

# ── Helper: remove existing and create symlink ─────────────────
link() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak.$(date +%s)" && echo "  backed up: $dst"
  [ -L "$dst" ] && rm "$dst"
  ln -s "$src" "$dst"
}

# ── Packages: native (pacman) ───────────────────────────────────
if [ -f "$DOTFILES/packages-native.txt" ]; then
  echo "Installing native packages..."
  sudo pacman -S --needed --noconfirm - <"$DOTFILES/packages-native.txt"
  echo "✓ native packages"
fi

# ── Packages: yay bootstrap (if missing) ────────────────────────
if ! command -v yay &>/dev/null; then
  echo "yay not found, bootstrapping..."
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
  echo "✓ yay bootstrapped"
fi

# ── Packages: AUR (yay) ──────────────────────────────────────────
# NOTE: --noconfirm skips the PKGBUILD review prompt. Given the June 2026
# "Atomic Arch" AUR supply-chain campaign (orphaned packages hijacked to
# inject infostealer malware), periodically audit packages-aur.txt by hand
# and consider reviewing PKGBUILDs (`yay -Gp <pkg>`) before adding new entries.
if [ -f "$DOTFILES/packages-aur.txt" ]; then
  echo "Installing AUR packages..."
  yay -S --needed --noconfirm - <"$DOTFILES/packages-aur.txt"
  echo "✓ AUR packages"
fi

# ── Configs ──────────────────────────────────────────────────
link "$DOTFILES/hypr" ~/.config/hypr
echo "✓ hypr"
link "$DOTFILES/waybar" ~/.config/waybar
echo "✓ waybar"
link "$DOTFILES/rofi" ~/.config/rofi
echo "✓ rofi"
link "$DOTFILES/kitty" ~/.config/kitty
echo "✓ kitty"
link "$DOTFILES/gtk-3.0" ~/.config/gtk-3.0
echo "✓ gtk-3.0"
link "$DOTFILES/gtk-4.0" ~/.config/gtk-4.0
echo "✓ gtk-4.0"
link "$DOTFILES/xdg-desktop-portal" ~/.config/xdg-desktop-portal
echo "✓ xdg-desktop-portal"
link "$DOTFILES/nvim" ~/.config/nvim
echo "✓ nvim"
link "$DOTFILES/mako" ~/.config/mako
echo "✓ mako"
link "$DOTFILES/btop" ~/.config/btop
echo "✓ btop"
link "$DOTFILES/ttyper" ~/.config/ttyper
echo "✓ ttyper"
link "$DOTFILES/fastfetch" ~/.config/fastfetch
echo "✓ fastfetch"
link "$DOTFILES/yazi" ~/.config/yazi
echo "✓ yazi"
link "$DOTFILES/cava" ~/.config/cava
echo "✓ cava"
link "$DOTFILES/lazygit" ~/.config/lazygit
echo "✓ lazygit"
link "$DOTFILES/peaclock/config" ~/.peaclock/config
echo "✓ peaclock"
link "$DOTFILES/zshrc" ~/.zshrc
# [ -f "$DOTFILES/.p10k.zsh" ] && link "$DOTFILES/.p10k.zsh" ~/.p10k.zsh
link "$DOTFILES/starship/starship.toml" ~/.config/starship.toml
echo "✓ zsh"

# ── Zsh plugins ───────────────────────────────────────────────
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
echo "✓ zsh plugins"

# ── ly (display manager) ────────────────────────────────────────
# Replaces SDDM. ly is a lightweight TUI display manager — no custom
# config.ini symlinked here, just installed (via packages-native.txt or
# packages-aur.txt) and enabled with its default settings.
if command -v ly &>/dev/null || pacman -Qi ly &>/dev/null; then
  sudo systemctl disable sddm.service 2>/dev/null || true
  sudo systemctl enable ly.service
  echo "✓ ly enabled"
else
  echo "⚠ ly not found — add 'ly' to packages-native.txt or packages-aur.txt"
fi

# ── TLP ──────────────────────────────────────────────────────
if [ -f "$DOTFILES/tlp.conf" ]; then
  sudo cp "$DOTFILES/tlp.conf" /etc/tlp.conf
  sudo systemctl enable --now tlp.service
  echo "✓ tlp"
fi

# ── RyzenAdj power limit service ────────────────────────────
if [ -f "$DOTFILES/ryzenadj.service" ]; then
  sudo cp "$DOTFILES/ryzenadj.service" /etc/systemd/system/ryzenadj.service
  sudo systemctl daemon-reload
  sudo systemctl enable --now ryzenadj.service
  echo "✓ ryzenadj"
fi

# ── Cargo packages ────────────────────────────────────────────
if command -v cargo &>/dev/null; then
  if ! command -v ttyper &>/dev/null; then
    cargo install ttyper
    echo "✓ ttyper installed"
  else
    echo "✓ ttyper already installed, skipping"
  fi
else
  echo "⚠ cargo not found, skipping ttyper install"
fi

# ── Neovim formatter tooling ────────────────────────────────────
# LazyVim's conform.nvim needs these binaries on $PATH to actually format.
echo "Installing Neovim formatter tooling..."
sudo pacman -S --needed --noconfirm clang stylua jq shfmt
echo "✓ clang, stylua, jq, shfmt"

pip install --break-system-packages --quiet black
echo "✓ black"

if ! command -v prettier &>/dev/null; then
  mkdir -p ~/.npm-global
  npm config set prefix "$HOME/.npm-global"
  if ! grep -q '.npm-global/bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >>~/.zshrc
  fi
  export PATH="$HOME/.npm-global/bin:$PATH"
  npm install -g prettier
  echo "✓ prettier"
else
  echo "✓ prettier already installed, skipping"
fi

echo ""
echo "✅ Done! All configs symlinked, packages installed, services enabled."
echo "Reboot or restart Hyprland to apply changes."
echo "Neovim plugins will auto-install on first launch."
