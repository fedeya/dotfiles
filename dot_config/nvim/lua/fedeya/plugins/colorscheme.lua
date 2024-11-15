return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = false,
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
					neogit = true,
					flash = true,
					neotest = true,
					render_markdown = true,
					harpoon = true,
					treesitter = true,
					markdown = true,
					dashboard = true,
					-- treesitter_context = true,
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

						inlay_hints = {
							background = true,
						},
					},
					-- barbar = true,
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
							-- PmenuSel = { bg = "#ABE9B3", fg = "#1e1d2d" },
							PmenuSel = { bg = mocha.lavender, fg = mocha.base },
							CmpBorder = { fg = "#474656" },
							-- CmpSel = { bg = "#ABE9B3", fg = "#1e1d2d" },
							CmpSel = { bg = mocha.lavender, fg = mocha.base },
							CmpPmenu = { bg = "#1E1D2D" },
							CmpDoc = { bg = mocha.base },
							CmpDocBorder = { bg = "#191828", fg = "#191828" },
							FlashLabel = { bg = "#ABE9B3", fg = "#1e1d2d" },
							MsgArea = { bg = mocha.mantle },
						}
					end,
				},
			})

			-- vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		lazy = false,
		opts = {
			highlight_groups = {
				CmpSel = { bg = "overlay" },
				CmpBorder = { fg = "muted", bg = "surface" },
				Pmenu = { bg = "surface" },
				PmenuSel = { bg = "overlay" },
				CmpPmenu = { bg = "surface" },
				CmpDoc = { bg = "surface" },

				-- NeoTree
				-- VertSplit = { fg = "#ffffff", bg = "surface" },
				-- NeoTreeEndOfBuffer = { fg = "#ffffff", bg = "#ffffff" },
				-- NeoTreeVertSplit = { fg = "surface", bg = "surface" },
				-- NeoTreeWinSeparator = { fg = "surface", bg = "surface" },
				-- NeoTreeNormal = { bg = "surface" },
				-- NeoTreeNormalNC = { bg = "surface" },
			},
		},
		init = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},
}
