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
					enabled = false,
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
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		enabled = false,
		opts = function()
			return {
				symbol = "│",
				draw = {
					animation = require("mini.indentscope").gen_animation.none(),
				},
				options = { try_as_border = true },
			}
		end,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"NvimTree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"neotest-summary",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	{
		"goolord/alpha-nvim",
		cmd = "Alpha",
		enabled = false,
		init = function()
			if vim.fn.argc() == 0 then
				require("alpha").setup(require("alpha.themes.startify").config)
			end
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",

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
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		enabled = false,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		enabled = false,
		keys = {
			{
				"<Tab>",
				"<Cmd>BufferLineCycleNext<CR>",
				desc = "Next buffer",
			},
			{
				"<S-Tab>",
				"<Cmd>BufferLineCyclePrev<CR>",
				desc = "Previous buffer",
			},
			-- {
			-- 	"<Leader>bp",
			-- 	"<Cmd>BufferLinePick<CR>",
			-- 	desc = "Pick buffer",
			-- },
			{
				"]b",
				"<Cmd>BufferLineMoveNext<CR>",
				desc = "Move buffer to the right",
			},
			{
				"[b",
				"<Cmd>BufferLineMovePrev<CR>",
				desc = "Move buffer to the left",
			},
		},
		opts = function()
			return {
				-- highlights = require("catppuccin.groups.integrations.bufferline").get(),
				options = {
					sort_by = "insert_after_current",
					diagnostics = "nvim_lsp",
					always_show_bufferline = false,
					close_command = function(n)
						require("mini.bufremove").delete(n, false)
					end,
					right_mouse_command = function(n)
						require("mini.bufremove").delete(n, true)
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "center",
						},
					},
				},
			}
		end,
		config = function(_, opts)
			require("bufferline").setup(opts)

			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						---@diagnostic disable-next-line: undefined-global
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},
	{
		"romgrk/barbar.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		enabled = false,
		opts = {
			animation = false,
		},
		keys = {
			{
				"<Tab>",
				"<Cmd>BufferNext<CR>",
			},
			{
				"<S-Tab>",
				"<Cmd>BufferPrevious<CR>",
			},
			{
				"<Leader>bp",
				"<Cmd>BufferPick<CR>",
			},
		},
		-- version = "^1.0.0", -- optional: only update when a new 1.x version is released
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
			return {
				options = {
					theme = "rose-pine",
					icons_enabled = true,
					globalstatus = true,
					-- section_separators = { left = "", right = "" },

					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "starter" },
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
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
