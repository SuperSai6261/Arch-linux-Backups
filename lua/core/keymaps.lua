-- ============================================================
--  Keymaps
-- ============================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── General ─────────────────────────────────────────────────
map("n", "<leader>w",  "<cmd>w<CR>",          { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<CR>",          { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<CR>",        { desc = "Force quit all" })
map("n", "<Esc>",      "<cmd>nohlsearch<CR>", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          opts)
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          opts)
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Split horizontal" })
map("n", "<leader>sc", "<cmd>close<CR>",  { desc = "Close split" })

-- Buffer navigation
map("n", "<S-h>",      "<cmd>bprevious<CR>",  { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<CR>",      { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>",    { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>",   { desc = "Force delete buffer" })

-- Move lines (visual)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n",     "nzzzv",   opts)
map("n", "N",     "Nzzzv",   opts)

-- Better paste (don't clobber register)
map("v", "p", '"_dP', opts)

-- Indent stay in visual
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- ── Telescope ───────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",              { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",               { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",                 { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",               { desc = "Help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",                { desc = "Recent files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",    { desc = "Symbols" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>",             { desc = "Diagnostics" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>",                 { desc = "Keymaps" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>",             { desc = "Git commits" })

-- ── Neo-tree ────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree toggle<CR>",       { desc = "File explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<CR>",        { desc = "Focus explorer" })

-- ── LSP (set in lsp/init.lua on_attach, listed here for reference) ──

-- ── Terminal ────────────────────────────────────────────────
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal (horizontal)" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",      { desc = "Terminal (float)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>",                              { desc = "Exit terminal mode" })

-- ── DAP (Debugger) ───────────────────────────────────────────
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>",          { desc = "Continue" })
map("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>",         { desc = "Step into" })
map("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>",         { desc = "Step over" })
map("n", "<leader>dO", "<cmd>lua require('dap').step_out()<CR>",          { desc = "Step out" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>",          { desc = "DAP UI" })
map("n", "<leader>dq", "<cmd>lua require('dap').terminate()<CR>",         { desc = "Terminate" })

-- ── Misc ─────────────────────────────────────────────────────
map("n", "<leader>lz", "<cmd>Lazy<CR>",   { desc = "Lazy plugin manager" })
map("n", "<leader>mm", "<cmd>Mason<CR>",  { desc = "Mason LSP installer" })
map("n", "<leader>gg", "<cmd>LazyGit<CR>",{ desc = "LazyGit" })
