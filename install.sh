#!/bin/bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES..."

# hypr
mkdir -p ~/.config/hypr
cp "$DOTFILES/hypr/hyprland.conf" ~/.config/hypr/
cp "$DOTFILES/hypr/hyprland-animations.conf" ~/.config/hypr/

# waybar
mkdir -p ~/.config/waybar
cp "$DOTFILES/waybar/config.jsonc" ~/.config/waybar/
cp "$DOTFILES/waybar/style.css" ~/.config/waybar/

# kitty
mkdir -p ~/.config/kitty
cp "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/

# nvim
mkdir -p ~/.config/nvim
cp -r "$DOTFILES/nvim/"* ~/.config/nvim/

# zsh
cp "$DOTFILES/zshrc" ~/.zshrc

echo "Done! Restart your apps to apply changes."
