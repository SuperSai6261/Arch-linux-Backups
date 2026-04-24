#!/bin/bash
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
echo "Installing dotfiles from $DOTFILES..."

backup() {
  [ -e "$1" ] && [ ! -L "$1" ] && mv "$1" "$1.bak.$(date +%s)" && echo "  backed up: $1"
}

mkdir -p ~/.config/hypr
backup ~/.config/hypr/hyprland.conf
backup ~/.config/hypr/hyprland-animations.conf
cp "$DOTFILES/hypr/hyprland.conf" ~/.config/hypr/
cp "$DOTFILES/hypr/hyprland-animations.conf" ~/.config/hypr/
echo "✓ hypr"

mkdir -p ~/.config/waybar
cp "$DOTFILES/waybar/config.jsonc" ~/.config/waybar/
cp "$DOTFILES/waybar/style.css" ~/.config/waybar/
echo "✓ waybar"

mkdir -p ~/.config/wofi
cp "$DOTFILES/wofi/config" ~/.config/wofi/
cp "$DOTFILES/wofi/style.css" ~/.config/wofi/
echo "✓ wofi"

mkdir -p ~/.config/kitty
cp "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/
echo "✓ kitty"

mkdir -p ~/.config/nvim
cp -r "$DOTFILES/nvim/"* ~/.config/nvim/
echo "✓ nvim"

cp "$DOTFILES/zshrc" ~/.zshrc
[ -f "$DOTFILES/.p10k.zsh" ] && cp "$DOTFILES/.p10k.zsh" ~/.p10k.zsh
echo "✓ zsh"

# Install zsh plugins
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
echo "✓ zsh plugins"

echo ""
echo "Done! Reboot or restart Hyprland to apply changes."
echo "Neovim plugins will auto-install on first launch."
