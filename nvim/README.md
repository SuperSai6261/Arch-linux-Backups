# xstream dotfiles
Arch Linux + Hyprland setup. Clone and run install.sh to restore everything.

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
| System monitor | Btop |
| Fetch | Fastfetch |
| PDF viewer | Zathura |
| Image viewer | Imv |
| Video player | Mpv |
| Power management | TLP |
| Cursor | Rose Pine Hyprcursor |

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
git clone https://github.com/SuperSai6261/Arch-linux-Backups.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

### 6. Install TLP power management
```bash
sudo pacman -S tlp tlp-rdw
sudo systemctl enable --now tlp
sudo cp ~/dotfiles/tlp.conf /etc/tlp.conf
sudo systemctl start tlp
```

### 7. Install cursor theme
```bash
yay -S rose-pine-hyprcursor
```

### 8. Install additional tools
```bash
sudo pacman -S zathura zathura-pdf-mupdf imv mpv brightnessctl
```

### 9. Start services
```bash
systemctl enable --now bluetooth NetworkManager tlp
systemctl enable sddm
chsh -s $(which zsh)
```

---

## What install.sh symlinks
| Source | Destination |
|--------|-------------|
| hypr/ | ~/.config/hypr |
| waybar/ | ~/.config/waybar |
| wofi/ | ~/.config/wofi |
| kitty/ | ~/.config/kitty |
| nvim/ | ~/.config/nvim |
| mako/config | ~/.config/mako/config |
| btop/btop.conf | ~/.config/btop/btop.conf |
| fastfetch/ | ~/.config/fastfetch |
| yazi/opener.toml | ~/.config/yazi/opener.toml |
| zshrc | ~/.zshrc |

---

## Notes
- Neovim plugins auto-install on first launch via lazy.nvim
- Neovim uses nvim 0.11+ native vim.lsp.config (no lspconfig dependency)
- Fonts needed: ttf-jetbrains-mono-nerd, ttf-meslo-nerd
- Icons: papirus-icon-theme
- TLP config stored in dotfiles/tlp.conf — copy to /etc/tlp.conf on restore
- Battery charge thresholds set to 75-80% for longevity
