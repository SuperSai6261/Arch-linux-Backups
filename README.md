# xstream dotfiles

Arch Linux + Hyprland setup. Clone and run `install.sh` to restore everything.

## Setup overview

| Component | Tool |
|-----------|------|
| WM | Hyprland |
| Bar | Waybar |
| Launcher | Wofi |
| Terminal | Kitty |
| Editor | Neovim |
| Shell | Zsh + Oh My Zsh + Powerlevel10k |
| Notifications | Mako |
| Clipboard | cliphist + wl-clipboard |
| Bluetooth | Blueman |
| File manager | Yazi |
| Screenshots | Grimblast |
| Display manager | SDDM |

---

## Fresh install steps

### 1. Install yay
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### 2. Install all packages
```bash
yay -S --needed - < packages.txt
```

### 3. Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. Install Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 5. Clone and apply dotfiles
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

### 6. Start services
```bash
systemctl enable --now bluetooth NetworkManager
systemctl enable sddm
chsh -s $(which zsh)
```

---

## What install.sh copies

| Source | Destination |
|--------|-------------|
| hypr/ | ~/.config/hypr/ |
| waybar/ | ~/.config/waybar/ |
| wofi/ | ~/.config/wofi/ |
| kitty/ | ~/.config/kitty/ |
| nvim/ | ~/.config/nvim/ |
| zshrc | ~/.zshrc |
| .p10k.zsh | ~/.p10k.zsh |

---

## Notes
- Neovim plugins auto-install on first launch via lazy.nvim
- Fonts needed: ttf-jetbrains-mono-nerd, ttf-meslo-nerd
- Icons: papirus-icon-theme
