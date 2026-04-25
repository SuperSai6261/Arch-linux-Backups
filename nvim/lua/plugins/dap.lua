-- ============================================================
--  DAP — Debug Adapter Protocol
--  C/C++ (codelldb), Python (debugpy), Java (via jdtls)
-- ============================================================
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap    = require("dap")
          local dapui  = require("dapui")
          dapui.setup({
            icons     = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings  = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e", repl = "r", toggle = "t" },
            layouts   = {
              {
                elements = {
                  { id = "scopes",      size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks",      size = 0.25 },
                  { id = "watches",     size = 0.25 },
                },
                size     = 40,
                position = "left",
              },
              {
                elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
                size     = 10,
                position = "bottom",
              },
            },
            floating  = { max_height = nil, max_width = nil, border = "rounded" },
          })
          -- Auto open/close DAP UI
          dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
        end,
      },

      -- Virtual text for debug values
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled                 = true,
          enabled_commands        = true,
          highlight_changed_variables = true,
          show_stop_reason        = true,
          virt_text_pos           = "eol",
        },
      },

      -- Mason DAP bridge
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
          ensure_installed = { "codelldb", "debugpy" },
          automatic_installation = true,
          handlers = {},
        },
      },

      -- Python DAP
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          require("dap-python").setup(debugpy_path)
          require("dap-python").test_runner = "pytest"
        end,
      },
    },

    config = function()
      local dap  = require("dap")
      local sign = vim.fn.sign_define

      -- Signs
      sign("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition",linehl = "", numhl = "" })
      sign("DapBreakpointRejected",  { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
      sign("DapLogPoint",            { text = "◎", texthl = "DapLogPoint",           linehl = "", numhl = "" })
      sign("DapStopped",             { text = "▶", texthl = "DapStopped",            linehl = "DapStoppedLine", numhl = "" })

      -- ── C / C++ — codelldb ────────────────────────────────
      local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type    = "server",
        port    = "${port}",
        executable = {
          command = codelldb_path,
          args    = { "--port", "${port}" },
        },
      }
      dap.configurations.c = {
        {
          name    = "Launch file (C)",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
          args        = {},
        },
        {
          name    = "Attach to process",
          type    = "codelldb",
          request = "attach",
          pid     = require("dap.utils").pick_process,
          args    = {},
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- ── Java — handled by nvim-jdtls (see plugins/java.lua) ──
    end,
  },
}
