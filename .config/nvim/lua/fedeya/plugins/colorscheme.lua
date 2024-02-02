return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = {
					light = "latte",
					dark = "mocha",
				},
				-- term_colors = true,
				-- no_bold = false,
				integrations = {
					cmp = true,
					lsp_saga = true,
					-- nvimtree = true,
					neotree = true,
					flash = true,
					treesitter = true,
					treesitter_context = true,
					ufo = true,
					-- leap = true,
					indent_blankline = { enabled = true },
					mini = {
						enabled = true,
						indentscope_color = "lavender",
					},
					illuminate = {
						enabled = true,
					},
					gitsigns = true,
					-- hop = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					barbar = true,
					mason = true,
					noice = true,
					lsp_trouble = true,
					which_key = true,
					semantic_tokens = true,
					alpha = true,
					telescope = {
						enabled = true,
					},
				},
				color_overrides = {
					-- mocha = {
					-- 	base = "#191927",
					-- 	crust = "#12121c",
					-- 	mantle = "#14141f",
					-- },
				},
				highlight_overrides = {
					mocha = function(mocha)
						return {
							NormalFloat = { bg = mocha.base },
							Pmenu = { bg = mocha.base },
							PmenuSel = { bg = "#ABE9B3", fg = "#1e1d2d" },
							CmpBorder = { fg = "#474656" },
							CmpSel = { bg = "#ABE9B3", fg = "#1e1d2d" },
							CmpPmenu = { bg = "#1E1D2D" },
							CmpDoc = { bg = "#191828" },
							CmpDocBorder = { bg = "#191828", fg = "#191828" },
							FlashLabel = { bg = "#ABE9B3", fg = "#1e1d2d" },
						}
					end,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
