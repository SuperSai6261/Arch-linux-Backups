-- ============================================================
--  LSP core: on_attach, capabilities, server setup
-- ============================================================
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- ── Capabilities ─────────────────────────────────────────────
local capabilities =
	vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())

-- ── Diagnostics ──────────────────────────────────────────────
vim.diagnostic.config({
	virtual_text = { prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "always" },
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- ── on_attach ────────────────────────────────────────────────
local on_attach = function(client, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end
	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gD", vim.lsp.buf.declaration, "Go to declaration")
	map("gi", vim.lsp.buf.implementation, "Go to implementation")
	map("gr", vim.lsp.buf.references, "References")
	map("gt", vim.lsp.buf.type_definition, "Type definition")
	map("K", vim.lsp.buf.hover, "Hover docs")
	map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
	map("<leader>rn", vim.lsp.buf.rename, "Rename")
	map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format")
	map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
	map("]d", vim.diagnostic.goto_next, "Next diagnostic")
	map("<leader>dl", vim.diagnostic.open_float, "Line diagnostics")

	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- ── Servers ───────────────────────────────────────────────────
lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		"clangd",
		"--background-index=false",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
})

lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
			},
		},
	},
})

lspconfig.bashls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
			hint = { enable = true },
		},
	},
})

-- jdtls (Java) is handled in plugins/java.lua
