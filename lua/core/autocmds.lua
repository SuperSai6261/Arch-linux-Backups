-- ============================================================
--  Autocommands
-- ============================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Highlight on yank ────────────────────────────────────────
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group    = "YankHighlight",
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})

-- ── Restore cursor position ──────────────────────────────────
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group    = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- ── Auto resize splits on terminal resize ────────────────────
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group    = "ResizeSplits",
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- ── Remove trailing whitespace on save ───────────────────────
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group   = "TrimWhitespace",
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.java", "*.py", "*.sh", "*.lua" },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- ── Language-specific indent settings ────────────────────────
augroup("LangIndent", { clear = true })
autocmd("FileType", {
  group   = "LangIndent",
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab  = true
  end,
})
autocmd("FileType", {
  group   = "LangIndent",
  pattern = { "java" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab  = true
  end,
})
autocmd("FileType", {
  group   = "LangIndent",
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab  = true
  end,
})
autocmd("FileType", {
  group   = "LangIndent",
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.tabstop    = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab  = true
  end,
})
autocmd("FileType", {
  group   = "LangIndent",
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop    = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab  = true
  end,
})

-- ── Close certain filetypes with <q> ─────────────────────────
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group   = "QuickClose",
  pattern = { "help", "lspinfo", "man", "checkhealth", "qf", "spectre_panel" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})

-- ── Auto-format on save (via conform.nvim) ───────────────────
-- Actual formatting is handled in plugins/formatting.lua
