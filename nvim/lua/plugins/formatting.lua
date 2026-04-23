-- ============================================================
--  Formatting — conform.nvim
--  clang-format (C/C++), google-java-format (Java),
--  black + isort (Python), shfmt (Bash)
-- ============================================================
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    keys  = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format file/selection",
      },
    },
    opts = {
      formatters_by_ft = {
        c          = { "clang_format" },
        cpp        = { "clang_format" },
        java       = { "google_java_format" },
        python     = { "isort", "black" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
        lua        = { "stylua" },
        json       = { "prettierd", "prettier" },
        yaml       = { "prettierd", "prettier" },
        markdown   = { "prettierd", "prettier" },
        ["_"]      = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms   = 1000,
        lsp_fallback = true,
      },
      formatters = {
        clang_format = {
          prepend_args = { "--style=file,{BasedOnStyle: LLVM, IndentWidth: 4}" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        black = {
          prepend_args = { "--line-length", "100" },
        },
        isort = {
          prepend_args = { "--profile", "black" },
        },
      },
    },
    init = function()
      -- Use conform for gq formatting
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        c       = { "cppcheck" },
        cpp     = { "cppcheck" },
        python  = { "flake8" },
        sh      = { "shellcheck" },
        bash    = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
