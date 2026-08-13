# xstream dotfiles

Arch Linux + Hyprland setup. Clone and run install.sh to restore everything — packages, configs, and services.

## Setup overview

| Component        | Tool                                          |
| ---------------- | --------------------------------------------- |
| WM               | Hyprland (experimental `hyprland.lua` config) |
| Bar              | Waybar                                        |
| Launcher         | Rofi (wayland)                                |
| Terminal         | Kitty                                         |
| Editor           | Neovim (LazyVim)                              |
| Shell            | Zsh + Oh My Zsh + Starship                    |
| Notifications    | Mako                                          |
| Clipboard        | cliphist + wl-clipboard                       |
| Bluetooth        | Blueman                                       |
| File manager     | Yazi                                          |
| Screenshots      | Flameshot                                     |
| Display manager  | SDDM                                          |
| System monitor   | Btop                                          |
| Fetch            | Fastfetch                                     |
| PDF viewer       | Zathura                                       |
| Image viewer     | Imv                                           |
| Video player     | Mpv                                           |
| Power management | TLP + RyzenAdj                                |
| Cursor           | Rose Pine Hyprcursor                          |
| Timer / Clock    | Peaclock                                      |

---

## Theme / Aesthetic

Pure neon on black across all tools:

- **Colors:** Hot pink `#FF007C`, Cyan `#00FFFF`, Green `#00FF00`, Yellow `#FFFF00` on pure black `#000000`
- **Neovim:** retrobox colorscheme (LazyVim, set via `nvim/lua/plugins/colorscheme.lua`)
- **Kitty:** Pure black background + neon colors
- **Yazi:** Custom neon theme (Yazi 26.x schema format)
- **Btop:** Custom `neon_black` theme
- **Peaclock:** Neon black theme (hot pink digits, cyan colons, yellow date)
- **GTK apps:** Arc-Darker base theme + custom black CSS override (gtk-3.0/gtk-4.0), Papirus-Dark icons — keeps nm-connection-editor, file pickers, and other GTK dialogs pure black instead of default light/glassy

---

## Fresh install steps

`install.sh` now installs all native + AUR packages automatically. Only a few bootstrap steps need to happen first.

### 1. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Install Starship

```bash
curl -sS https://starship.rs/install.sh | sh
```

### 3. Clone and run install.sh

```bash
git clone https://github.com/SuperSai6261/Arch-linux-Backups.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

This single step now handles:

- Installing all native packages (`packages-native.txt`) via pacman
- Bootstrapping `yay` if missing, then installing all AUR packages (`packages-aur.txt`)
- Symlinking every config below
- Copying `tlp.conf` to `/etc/tlp.conf` and enabling the TLP service
- Copying `ryzenadj.service` to `/etc/systemd/system/` and enabling it (sets APU power limits — see Notes)
- Copying the SDDM theme config
- Installing `ttyper` via cargo (if cargo is available)

### 4. Install nvim formatter tooling

LazyVim's `conform.nvim` handles formatting, but the underlying formatter binaries need to exist on the system:

```bash
sudo pacman -S clang stylua jq shfmt
pip install black --break-system-packages
```

`prettier` is installed via npm into a user-local prefix (avoids `sudo npm`):

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
npm install -g prettier
```

Enable the LazyVim formatting extras in `~/.config/nvim/lua/config/lazy.lua`:

```lua
spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "plugins" },
},
```

`stylua` and `clang_format`/`clangd` are picked up automatically by LazyVim core once the binaries are on `$PATH` — no extra import needed.

### 5. Start remaining services

```bash
systemctl enable --now bluetooth NetworkManager
systemctl enable sddm
chsh -s $(which zsh)
```

---

## What install.sh symlinks

| Source                 | Destination                  |
| ---------------------- | ---------------------------- |
| hypr/                  | ~/.config/hypr               |
| waybar/                | ~/.config/waybar             |
| rofi/                  | ~/.config/rofi               |
| starship/starship.toml | ~/.config/starship.toml      |
| kitty/                 | ~/.config/kitty              |
| nvim/                  | ~/.config/nvim               |
| mako/                  | ~/.config/mako               |
| btop/                  | ~/.config/btop               |
| ttyper/                | ~/.config/ttyper             |
| fastfetch/             | ~/.config/fastfetch          |
| yazi/                  | ~/.config/yazi               |
| cava/                  | ~/.config/cava               |
| lazygit/               | ~/.config/lazygit            |
| peaclock/config        | ~/.peaclock/config           |
| gtk-3.0/               | ~/.config/gtk-3.0            |
| gtk-4.0/               | ~/.config/gtk-4.0            |
| xdg-desktop-portal/    | ~/.config/xdg-desktop-portal |
| zshrc                  | ~/.zshrc                     |

## What install.sh installs (non-symlink)

| File in repo        | Installed to                | Purpose                                  |
| ------------------- | --------------------------- | ---------------------------------------- |
| packages-native.txt | via `pacman -S`             | official repo packages                   |
| packages-aur.txt    | via `yay -S`                | AUR packages                             |
| tlp.conf            | /etc/tlp.conf               | battery/power tuning, service enabled    |
| ryzenadj.service    | /etc/systemd/system/        | APU power limit on boot, service enabled |
| theme.conf          | /etc/sddm.conf.d/theme.conf | SDDM theme                               |

---

## Notes

- **Hyprland config migrated from `hyprland.conf` to the experimental Lua-based `hyprland.lua` format.** Requires Hyprland's Lua config support; test changes in a nested Hyprland window before applying to the main session, since `hl.env()` and other Lua-specific calls have different argument syntax than the old `.conf` format.
- **Screenshots switched from grim+slurp/grimblast to Flameshot.** `custom/screenshot` waybar module: left-click = `flameshot gui` (area select), right-click = `flameshot full -p ~/Pictures/Screenshots/` (full virtual screen), middle-click = `flameshot screen -p ~/Pictures/Screenshots/` (current monitor). Flameshot has no true single-window capture — only fullscreen, current-screen, or manual area select.
- Neovim plugins auto-install on first launch via lazy.nvim
- Neovim uses nvim 0.11+ native vim.lsp.config (no lspconfig dependency)
- Neovim formatting is handled by `conform.nvim` (bundled with LazyVim) — see "Install nvim formatter tooling" above. Check per-buffer formatter status anytime with `:ConformInfo`.
- Fonts needed: `ttf-jetbrains-mono-nerd`, `ttf-meslo-nerd`
- Icons: `papirus-icon-theme`
- TLP config stored in dotfiles/tlp.conf — applied automatically by install.sh
- Battery charge thresholds set to 75-80% for longevity
- RyzenAdj sets APU power limits on every boot: STAPM 15W, fast 20W, slow 15W — tuned for the Radeon 780M to manage sustained thermals. Runs via `/dev/mem` fallback since no `ryzen_smu` kernel module is installed; if STAPM limit doesn't stick after a kernel update, re-check with `sudo ryzenadj -i` and consider installing a `ryzen_smu` DKMS package for a more reliable write path.
- Yazi theme uses 26.x schema format (`"$schema"` field required, `url` instead of `name` in filetype rules)
- Btop uses custom `neon_black` theme located in `btop/themes/neon_black.theme`
- Peaclock config at `~/.peaclock/config` — neon black theme matching btop/cava
- GTK dialogs (file pickers, nm-connection-editor) require `xdg-desktop-portal/hyprland-portals.conf` to respect the custom theme — without it, GTK4 apps fall back to default styling regardless of gtk.css
