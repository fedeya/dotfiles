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
				enabled = false,
				view = "mini",
				view_search = false,
			},
			notify = {
				enabled = true,
				view = "mini",
			},
			presets = {
				command_palette = true,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
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
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		enabled = false,

		opts = function()
			local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

			logo = string.rep("\n", 8) .. logo .. "\n\n\n"

			local opts = {
				theme = "doom",
				hide = {
					statusline = false,
					tabline = false,
				},
				config = {
					header = vim.split(logo, "\n"),
					center = {
						{
							action = "FzfLua files",
							desc = " Find file",
							icon = " ",
							key = "f",
						},
						{
							action = "ene | startinsert",
							desc = " New file",
							icon = " ",
							key = "n",
						},
						{
							action = "FzfLua oldfiles",
							desc = " Recent files",
							icon = " ",
							key = "r",
						},
						{
							action = "FzfLua live_grep",
							desc = " Find text",
							icon = " ",
							key = "g",
						},
						{
							action = 'lua require("persistence").load()',
							desc = " Restore Session",
							icon = " ",
							key = "s",
						},
						{
							action = "Lazy",
							desc = " Lazy",
							icon = "󰒲 ",
							key = "l",
						},
						{
							action = "qa",
							desc = " Quit",
							icon = " ",
							key = "q",
						},
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"",
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "DashboardLoaded",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			return opts
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
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

					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" },
						winbar = {},
					},
					always_divide_middle = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
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
						"filename",
					},
					lualine_x = {
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = function()
								return { fg = Snacks.util.color("Special") }
							end,
						},
					},
					lualine_y = {
						{
							"filetype",
						},
					},
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
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = { "lazy", "trouble", "neo-tree" },
			}
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
		main = "ibl",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"neotest-summary",
				},
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			-- vim.ui.select = function(...)
			-- 	require("lazy").load({ plugins = { "dressing.nvim" } })
			-- 	return vim.ui.select(...)
			-- end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
