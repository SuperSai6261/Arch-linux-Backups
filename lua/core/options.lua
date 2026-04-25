-- ============================================================
--  Core Options
-- ============================================================
local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.colorcolumn    = "100"
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.termguicolors  = true
opt.showmode       = false       -- lualine handles this
opt.laststatus     = 3          -- global statusline
opt.cmdheight      = 1
opt.pumheight      = 10         -- popup menu height

-- Indentation
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true
opt.autoindent     = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- Files
opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true
opt.undodir        = vim.fn.stdpath("data") .. "/undo"

-- Performance
opt.updatetime     = 200
opt.timeoutlen     = 300
opt.redrawtime     = 1500

-- Splits
opt.splitright     = true
opt.splitbelow     = true

-- Completion
opt.completeopt    = { "menuone", "noselect", "noinsert" }
opt.shortmess:append("c")

-- Folding (using treesitter)
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldenable     = false      -- start with all folds open
opt.foldlevel      = 99

-- Clipboard: handled in hyprland.lua via wl-clipboard
-- opt.clipboard = "unnamedplus" -- set conditionally there

-- Mouse
opt.mouse          = "a"

-- Misc
opt.conceallevel   = 0
opt.hidden         = true
opt.confirm        = true

-- Neovim 0.11+ native diff
opt.diffopt:append("linematch:60")

-- Use Zsh as the shell inside Neovim
vim.opt.shell     = "/bin/zsh"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote   = ""
vim.opt.shellxquote  = ""

-- ── Suppress unused provider warnings ────────────────────────
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
