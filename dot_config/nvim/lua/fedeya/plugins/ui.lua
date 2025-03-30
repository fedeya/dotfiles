return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = true,
				},
				signature = {
					enabled = false,
				},
				hover = {
					enabled = true,
				},
			},
			views = {
				cmdline_popup = {
					-- border = {
					--   style = border "CmpBorder"
					-- },
				},
			},
			messages = {
				enabled = true,
				view = "mini",
				view_search = "mini",
				view_error = "mini",
				view_warn = "mini",
			},
			notify = {
				enabled = true,
				view = "mini",
			},
			presets = {
				command_palette = true,
				lsp_doc_border = true,
				-- bottom_search = true,
			},
			routes = {
				-- {
				-- 	filter = {
				-- 		event = "msg_show",
				-- 		kind = "search_count",
				-- 	},
				-- 	opts = { skip = true },
				-- },
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
			},
		},
		config = function(_, opts)
			require("noice").setup(opts)
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"AndreM222/copilot-lualine",
		},
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			vim.o.laststatus = vim.g.lualine_laststatus

			return {
				options = {
					theme = "auto",
					icons_enabled = true,
					globalstatus = vim.o.laststatus == 3,
					-- section_separators = { left = "", right = "" },
					-- component_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" },
						winbar = {},
					},
					always_divide_middle = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							icon = "",
							separator = { left = "", right = "" },
							-- color = {
							-- 	fg = "#1c1d21",
							-- 	bg = "#b4befe",
							-- },
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "",
							separator = { left = "", right = "" },
							-- color = {
							-- 	fg = "#1c1d21",
							-- 	bg = "#7d83ac",
							-- },
						},
						{
							"diff",
							separator = { left = "", right = "" },
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict

								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
							-- color = {
							-- 	fg = "#1c1d21",
							-- 	bg = "#7d83ac",
							-- },
						},
					},
					lualine_c = {
						{
							"diagnostics",
							separator = { left = "", right = "" },
							-- color = {
							-- 	bg = "#45475a",
							-- },
						},
						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							path = 1,
							symbols = {
								unnamed = "",
							},
						},
					},
					lualine_x = {
						-- {
						--
						-- 	require("noice").api.status.search.get,
						-- 	cond = require("noice").api.status.search.has,
						-- 	color = { fg = "#ff9e64" },
						-- },
						"copilot",
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = function()
								return { fg = Snacks.util.color("Special") }
							end,
						},
					},
					lualine_y = { "filetype" },
					lualine_z = {
						{
							"location",
							icon = "",
							-- color = {
							-- 	fg = "#1c1d21",
							-- 	bg = "#f2cdcd",
							-- },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
						},
					},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = { "lazy" },
			}
		end,
	},
}
