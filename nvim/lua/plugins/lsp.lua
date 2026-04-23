-- ============================================================
--  LSP Configuration
--  mason.nvim + nvim-lspconfig + nvim-cmp
--  Servers: clangd, jdtls, pyright, bashls, lua_ls
-- ============================================================
return {
  -- Mason: LSP/DAP/Linter installer
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    opts = {
      ui = {
        border  = "rounded",
        icons   = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",       -- C / C++
        "jdtls",        -- Java  (jdtls has its own setup below)
        "pyright",      -- Python
        "bashls",       -- Bash / Shell
        "lua_ls",       -- Lua (for editing this config!)
      },
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} }, -- lua_ls aware of nvim API
    },
    config = function()
      require("lsp")
    end,
  },
}
