-- ============================================================
--  Java — nvim-jdtls
--  Full Eclipse JDT Language Server setup
--  Requires: mason to install jdtls
-- ============================================================
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls     = require("jdtls")
      local jdtls_setup = require("jdtls.setup")

      -- Determine workspace folder (per-project)
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
      local root_dir     = jdtls_setup.find_root(root_markers)
      local home         = os.getenv("HOME")
      local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
      local workspace    = home .. "/.cache/jdtls/workspaces/" .. project_name

      -- Mason jdtls path
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
      local jdtls_jar  = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      local os_config  = "linux"    -- Arch Linux
      local config_dir = mason_path .. "/config_" .. os_config

      -- Lombok support (common in Java projects)
      local lombok_jar = mason_path .. "/lombok.jar"
      local jvm_args   = {}
      if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(jvm_args, "-javaagent:" .. lombok_jar)
      end

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "-Xmx4g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          table.unpack(jvm_args),
          "-jar", jdtls_jar,
          "-configuration", config_dir,
          "-data", workspace,
        },

        root_dir = root_dir or vim.fn.getcwd(),

        settings = {
          java = {
            eclipse        = { downloadSources = true },
            configuration  = { updateBuildConfiguration = "interactive" },
            maven          = { downloadSources = true },
            implementationsCodeLens   = { enabled = true },
            referencesCodeLens        = { enabled = true },
            references     = { includeDecompiledSources = true },
            inlayHints     = { parameterNames = { enabled = "all" } },
            format = {
              enabled  = true,
              settings = {
                profile = "GoogleStyle",
                url     = home .. "/.config/nvim/lsp/java-google-style.xml",
              },
            },
            signatureHelp  = { enabled = true },
            contentProvider= { preferred = "fernflower" },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.junit.Assert.*",
                "org.junit.Assume.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
              },
              importOrder = { "java", "javax", "com", "org" },
            },
            sources = {
              organizeImports = {
                starThreshold         = 9999,
                staticStarThreshold   = 9999,
              },
            },
          },
        },

        -- Neovim 0.11+ native capabilities + cmp
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities()
        ),

        on_attach = function(client, bufnr)
          -- Standard LSP keymaps
          local map = function(k, f, d)
            vim.keymap.set("n", k, f, { buffer = bufnr, desc = "LSP: " .. d })
          end
          map("gd",         vim.lsp.buf.definition,      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,     "Go to declaration")
          map("gi",         vim.lsp.buf.implementation,  "Go to implementation")
          map("gr",         vim.lsp.buf.references,      "References")
          map("K",          vim.lsp.buf.hover,           "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename,          "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,     "Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("[d",         vim.diagnostic.goto_prev,    "Prev diagnostic")
          map("]d",         vim.diagnostic.goto_next,    "Next diagnostic")

          -- Java-specific
          map("<leader>jo", jdtls.organize_imports,                "Organize imports")
          map("<leader>jv", jdtls.extract_variable,               "Extract variable")
          map("<leader>jc", jdtls.extract_constant,               "Extract constant")
          map("<leader>jt", jdtls.test_nearest_method,            "Test nearest method")
          map("<leader>jT", jdtls.test_class,                     "Test class")
          map("<leader>ju", "<cmd>JdtUpdateConfig<CR>",           "Update jdtls config")

          -- Inlay hints
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- jdtls specific: dap integration
          jdtls.setup_dap({ hotcodereplace = "auto" })
          require("jdtls.dap").setup_dap_main_class_configs()
        end,

        flags = { allow_incremental_sync = true },

        -- jdtls extensions (optional test runner support)
        init_options = {
          bundles = (function()
            local bundles = {}
            -- java-debug adapter
            local debug_jar = vim.fn.glob(
              vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
              true, true
            )
            vim.list_extend(bundles, debug_jar)
            -- java-test
            local test_jars = vim.fn.glob(
              vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar",
              true, true
            )
            vim.list_extend(bundles, test_jars)
            return bundles
          end)(),
        },
      }

      -- Start jdtls for java buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "java",
        callback = function()
          jdtls.start_or_attach(config)
        end,
      })
    end,
  },
}
