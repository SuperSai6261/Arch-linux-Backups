-- ============================================================
--  LSP Configuration
--  mason.nvim + nvim 0.11+ native vim.lsp.config
-- ============================================================
return {
  -- Mason: LSP/DAP/Linter installer
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons  = {
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
        "clangd",
        "jdtls",
        "pyright",
        "bashls",
        "lua_ls",
      },
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig (kept for mason-lspconfig compatibility)
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("lsp")
    end,
  },
}
