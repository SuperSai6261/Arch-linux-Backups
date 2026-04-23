-- ============================================================
--  Treesitter — Syntax highlighting, indentation, folding
-- ============================================================
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    main   = "nvim-treesitter.configs",
    opts   = {
      ensure_installed = {
        "c", "cpp", "java", "python", "bash",
        "lua", "vim", "vimdoc",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "regex", "make", "cmake",
        "html", "css", "javascript",
      },
      sync_install  = false,
      auto_install  = true,
      highlight     = {
        enable  = true,
        disable = function(lang, buf)
          local max_filesize = 1024 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return true end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent      = { enable = true },
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps   = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable          = true,
          set_jumps       = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end   = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable        = true,
          swap_next     = { ["<leader>sp"] = "@parameter.inner" },
          swap_previous = { ["<leader>sP"] = "@parameter.inner" },
        },
      },
    },
  },
  -- Show current function/class context at top of screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost" },
    opts  = {
      enable            = true,
      max_lines         = 3,
      min_window_height = 20,
      mode              = "cursor",
    },
  },
}
