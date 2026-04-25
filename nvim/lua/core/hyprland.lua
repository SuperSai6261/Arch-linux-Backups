-- ============================================================
--  Hyprland / Wayland Tweaks
--  - wl-clipboard integration
--  - XDG env fixes
--  - Cursor and env passthrough
-- ============================================================

local function is_wayland()
  return os.getenv("WAYLAND_DISPLAY") ~= nil
    or os.getenv("XDG_SESSION_TYPE") == "wayland"
end

if is_wayland() then
  -- Use wl-clipboard for system clipboard
  -- Requires: sudo pacman -S wl-clipboard
  vim.g.clipboard = {
    name  = "wl-clipboard",
    copy  = {
      ["+"] = { "wl-copy", "--foreground", "--type", "text/plain" },
      ["*"] = { "wl-copy", "--foreground", "--primary", "--type", "text/plain" },
    },
    paste = {
      ["+"] = function()
        return vim.fn.systemlist('wl-paste --no-newline --type "text/plain;charset=utf-8" 2>/dev/null')
      end,
      ["*"] = function()
        return vim.fn.systemlist('wl-paste --no-newline --primary --type "text/plain;charset=utf-8" 2>/dev/null')
      end,
    },
    cache_enabled = false, -- important: disable caching on Wayland
  }
  vim.opt.clipboard = "unnamedplus"

  -- Fix cursor shape in Hyprland terminal (kitty/foot/alacritty)
  vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

  -- Neovim 0.11+: tell it we're in a proper GUI env
  vim.env.NVIM_WAYLAND = "1"

  -- XDG runtime dir fix (common Hyprland issue)
  if not os.getenv("XDG_RUNTIME_DIR") then
    local uid = vim.fn.system("id -u"):gsub("\n", "")
    vim.env.XDG_RUNTIME_DIR = "/run/user/" .. uid
  end

  -- Notify on start (optional, remove if annoying)
  vim.api.nvim_create_autocmd("VimEnter", {
    once    = true,
    callback = function()
      vim.defer_fn(function()
        vim.notify("󰣐 Wayland/Hyprland mode active — wl-clipboard enabled", vim.log.levels.INFO, {
          title = "Neovim",
        })
      end, 500)
    end,
  })
else
  -- Fallback for TTY or X11
  vim.opt.clipboard = "unnamedplus"
end

-- ── Hyprland: fix $TERM for some terminals ──────────────────
-- Alacritty sets TERM=alacritty which some tools don't know
if vim.env.TERM == "alacritty" then
  vim.env.TERM = "xterm-256color"
end

-- ── IME / input method fix for Wayland ──────────────────────
vim.env.QT_IM_MODULE   = nil  -- prevent Qt IM interference inside nvim
vim.env.GTK_IM_MODULE  = nil
