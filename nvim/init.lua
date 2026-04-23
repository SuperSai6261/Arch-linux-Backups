-- ============================================================
--  Neovim 0.11+ Config | Arch Linux + Hyprland
--  Author: Generated for you
--  Plugin Manager: lazy.nvim
-- ============================================================

-- Load core settings first
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.hyprland") -- Hyprland/Wayland tweaks

-- Bootstrap and load lazy.nvim
require("core.lazy")
