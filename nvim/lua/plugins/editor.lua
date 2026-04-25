-- ============================================================
--  Editor Plugins
--  which-key, autopairs, indent-blankline, gitsigns,
--  comment, surround, lazygit, toggleterm, trouble
-- ============================================================
return {

  -- ── Which-key ─────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      plugins  = { spelling = { enabled = true } },
      icons    = { breadcrumb = "»", separator = "➜", group = "+" },
      win      = { border = "rounded" },
      spec     = {
        { "<leader>b",  group = "buffer" },
        { "<leader>c",  group = "code" },
        { "<leader>d",  group = "debug" },
        { "<leader>f",  group = "find/file" },
        { "<leader>g",  group = "git" },
        { "<leader>j",  group = "java" },
        { "<leader>l",  group = "lazy" },
        { "<leader>m",  group = "mason" },
        { "<leader>s",  group = "split/swap" },
        { "<leader>t",  group = "terminal" },
        { "<leader>w",  group = "workspace/window" },
      },
    },
  },

  -- ── Autopairs ─────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts  = {
      check_ts        = true,    -- use treesitter
      ts_config       = { lua = { "string" }, java = false },
      fast_wrap       = {
        map    = "<M-e>",
        chars  = { "{", "[", "(", '"', "'" },
        pattern= [=[[%'%"%>%]%)%}%,]]=],
        end_key= "$",
        keys   = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma  = true,
        manual_position= true,
        highlight      = "Search",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp           = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Indent Blankline ─────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      indent  = { char = "│", highlight = "IblIndent" },
      scope   = { enabled = true, highlight = "IblScope" },
      exclude = {
        filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
      },
    },
  },

  -- ── Gitsigns ──────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs  = require("gitsigns")
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]g",          gs.next_hunk,                  "Next hunk")
        map("n", "[g",          gs.prev_hunk,                  "Prev hunk")
        map("n", "<leader>gs",  gs.stage_hunk,                 "Stage hunk")
        map("n", "<leader>gr",  gs.reset_hunk,                 "Reset hunk")
        map("n", "<leader>gS",  gs.stage_buffer,               "Stage buffer")
        map("n", "<leader>gu",  gs.undo_stage_hunk,            "Undo stage hunk")
        map("n", "<leader>gR",  gs.reset_buffer,               "Reset buffer")
        map("n", "<leader>gp",  gs.preview_hunk,               "Preview hunk")
        map("n", "<leader>gb",  function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gd",  gs.diffthis,                   "Diff this")
        map("n", "<leader>gtb", gs.toggle_current_line_blame,  "Toggle blame")
      end,
    },
  },

  -- ── Comment.nvim ──────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts  = {
      padding   = true,
      sticky    = true,
      toggler   = { line = "gcc", block = "gbc" },
      opleader  = { line = "gc",  block = "gb"  },
      extra     = { above = "gcO", below = "gco", eol = "gcA" },
      mappings  = { basic = true, extra = true },
    },
  },

  -- ── Surround ──────────────────────────────────────────────
  {
    "kylechui/nvim-surround",
    event   = "VeryLazy",
    version = "*",
    opts    = {},
  },

  -- ── ToggleTerm ────────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys    = { "<leader>tt", "<leader>tf" },
    opts    = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping   = [[<C-\>]],
      hide_numbers   = true,
      shade_terminals= true,
      shading_factor = 2,
      start_in_insert= true,
      persist_mode   = true,
      direction      = "float",
      close_on_exit  = true,
      shell          = vim.o.shell,
      float_opts     = { border = "curved", winblend = 3 },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- LazyGit integration
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit  = Terminal:new({
        cmd        = "lazygit",
        dir        = "git_dir",
        direction  = "float",
        float_opts = { border = "double" },
        on_open    = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })
      vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "LazyGit" })
    end,
  },

  -- ── Trouble (diagnostics list) ────────────────────────────
  {
    "folke/trouble.nvim",
    cmd          = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys         = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",                    desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",       desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>",            desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<CR>",                        desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>",                         desc = "Quickfix list" },
    },
    opts = {
      modes = {
        lsp = { win = { position = "right" } },
      },
    },
  },

  -- ── Todo-comments ─────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    cmd          = { "TodoTrouble", "TodoTelescope" },
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "]t",          function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t",          function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>ft",  "<cmd>TodoTelescope<CR>",                           desc = "Telescope todos" },
    },
    opts = {},
  },

  -- ── Mini extras ───────────────────────────────────────────
  {
    "echasnovski/mini.ai",
    version = false,
    event   = "VeryLazy",
    opts    = { n_lines = 500 },
  },
  {
    "echasnovski/mini.bufremove",
    version = false,
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Force delete buffer" },
    },
  },

  -- ── Illuminate (highlight word under cursor) ──────────────
  {
    "RRethy/vim-illuminate",
    event  = { "BufReadPost", "BufNewFile" },
    opts   = {
      delay   = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
