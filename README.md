# ✦ CyberNova Waybar — Hyprland Setup Guide

## File Locations
```
~/.config/waybar/config          ← Main waybar configuration
~/.config/waybar/style.css       ← Theme & styling
~/.config/hypr/hyprland.conf     ← Add the animation block from hyprland-animations.conf
```

## Required Packages (Install with pacman / yay)

```bash
# Core
sudo pacman -S waybar hyprland

# Nerd Fonts (for ALL icons to display correctly)
yay -S ttf-jetbrains-mono-nerd nerd-fonts-symbols-only
# OR install the complete nerd fonts meta:
yay -S nerd-fonts

# Screenshot
yay -S grimblast-git          # grimblast --notify copy area

# Screen Lock
sudo pacman -S hyprlock        # or: yay -S swaylock-effects-git

# Network Manager GUI
sudo pacman -S network-manager-applet nm-connection-editor

# Bluetooth Manager
sudo pacman -S blueman

# Taskbar icon theme
sudo pacman -S papirus-icon-theme
```

## Quick Install
```bash
mkdir -p ~/.config/waybar
cp config    ~/.config/waybar/config
cp style.css ~/.config/waybar/style.css

# Restart waybar
pkill waybar && waybar &
```

## Module Guide

| Module            | Left-click         | Middle-click  | Right-click         | Scroll     |
|-------------------|--------------------|---------------|---------------------|------------|
| Workspaces        | Switch workspace   | —             | —                   | Navigate ± |
| Clock             | Toggle date/time   | —             | Calendar mode       | Month nav  |
| Taskbar icon      | Focus/raise window | Close app     | Close app           | —          |
| Network           | nm-connection-editor | —           | nmtui in terminal   | —          |
| Bluetooth         | blueman-manager    | —             | rfkill toggle       | —          |
| Battery           | Toggle info        | —             | —                   | —          |
| Screenshot        | Area screenshot    | Window shot   | Full screen shot    | —          |
| Lock              | Lock screen (hyprlock) | —        | —                   | —          |
| Restart           | systemctl reboot   | —             | —                   | —          |
| Power Off         | systemctl poweroff | —             | —                   | —          |

## Timezone
The clock is set to `Asia/Kolkata` (IST). To change:
- Edit `"timezone"` in the `clock` module in `config`

## Troubleshooting Icons
If icons show as boxes/question marks:
```bash
fc-cache -fv
# Then restart waybar
pkill waybar && waybar &
```

## Customising Accent Colors
Edit these lines at the top of `style.css`:
- Active workspace glow: `rgba(99, 102, 241, ...)` — change to your preferred color
- Clock gradient: `linear-gradient(90deg, #818cf8 ...` — swap hex values
- Border accents: `.modules-left`, `.modules-center`, `.modules-right` border colors
