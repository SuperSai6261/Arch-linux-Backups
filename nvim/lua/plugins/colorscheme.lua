-- ============================================================
--  Catppuccin Mocha Colorscheme
-- ============================================================
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = {
			flavour = "mocha",
			background = { light = "latte", dark = "mocha" },
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				functions = { "bold" },
				keywords = { "italic" },
				booleans = { "bold" },
				types = { "bold" },
			},
			integrations = {
				cmp = true,
				gitsigns = true,
				neo_tree = true,
				treesitter = true,
				telescope = { enabled = true },
				which_key = true,
				mason = true,
				dap = { enabled = true, enable_ui = true },
				lsp_trouble = true,
				indent_blankline = { enabled = true, scope_color = "lavender" },
				bufferline = { enabled = true },
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = { background = true },
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
			-- force lualine to reload theme after colorscheme is set
			vim.defer_fn(function()
				local ok, lualine = pcall(require, "lualine")
				if ok then
					lualine.setup({
						options = {
							theme = "auto",
							globalstatus = true,
							component_separators = { left = "", right = "" },
							section_separators = { left = "", right = "" },
							disabled_filetypes = { statusline = { "dashboard", "alpha" } },
						},
						sections = {
							lualine_a = { { "mode", icon = "" } },
							lualine_b = {
								"branch",
								{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
							},
							lualine_c = {
								{ "filename", path = 1, symbols = { modified = "●", readonly = "", unnamed = "" } },
								{
									"diagnostics",
									sources = { "nvim_lsp" },
									symbols = { error = " ", warn = " ", hint = "󰠠 ", info = " " },
								},
							},
							lualine_x = {
								{
									function()
										return require("noice").api.status.command.get()
									end,
									cond = function()
										return package.loaded["noice"] and require("noice").api.status.command.has()
									end,
								},
								"encoding",
								"fileformat",
								{ "filetype", icon_only = false },
							},
							lualine_y = { "progress" },
							lualine_z = { { "location", icon = "" } },
						},
					})
				end
			end, 500)
		end,
	},
}
