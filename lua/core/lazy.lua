-- ============================================================
--  lazy.nvim Bootstrap
--  Compatible with Neovim 0.11+
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy    = true,  -- lazy-load everything by default
    version = false, -- always use latest git commit
  },
  install = {
    colorscheme = { "catppuccin" },
  },
  ui = {
    border = "rounded",
    icons  = {
      cmd    = "⌘",
      config = "🛠",
      event  = "📅",
      ft     = "📂",
      init   = "⚙",
      keys   = "🗝",
      plugin = "🔌",
      runtime= "💻",
      source = "📄",
      start  = "🚀",
      task   = "📌",
      lazy   = "💤 ",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
  rocks = { enabled = false },
  checker = {
    enabled = true,   -- auto-check for plugin updates
    notify  = false,  -- don't notify on startup
  },
  change_detection = {
    notify = false,
  },
})
