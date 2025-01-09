return {
	-- buffer remove
	{
		"echasnovski/mini.bufremove",
		opts = {
			-- silent = true,
		},
		keys = {
			{
				"<leader>qb",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
		},
	},

	{
		"folke/twilight.nvim",
		opts = {},
		cmd = {
			"Twilight",
			"TwilightEnable",
			"TwilightDisable",
		},
	},

	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				-- width = 0.7,
			},
			plugins = {
				kitty = {
					enabled = true,
				},
			},
		},
		cmd = "ZenMode",
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>H",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>h",
					function()
						local harpoon = require("harpoon")

						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
				{
					"<Tab>",
					function()
						require("harpoon"):list():prev()
					end,
					desc = "Harpoon to Previous",
				},
				{
					"<S-Tab>",
					function()
						require("harpoon"):list():next()
					end,
					desc = "Harpoon to Next",
				},
			}

			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end

			return keys
		end,
	},

	{
		"LunarVim/bigfile.nvim",
		event = "BufReadPre",
		config = function()
			require("bigfile").setup({
				filesize = 1,
			})
		end,
	},

	-- marks plugin
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			require("marks").setup({
				default_mappings = true,
			})
		end,
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			under_cursor = false,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		enabled = false,
		keys = {
			{
				"<leader>e",
				"<cmd>NvimTreeToggle<cr>",
			},
			{
				"<leader>b",
				"<cmd>NvimTreeFocus<cr>",
			},
		},
		init = function()
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("nvim-tree")
				end
			end
		end,
		config = function()
			require("nvim-tree").setup({
				filters = {
					dotfiles = false,
					git_ignored = false,
					custom = { "^.git$", "^.DS_Store$" },
				},
				auto_reload_on_write = true,
				view = {
					width = 40,
					side = "right",
					debounce_delay = 15,
				},
				renderer = {
					indent_markers = {
						enable = false,
					},
				},
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					api.config.mappings.default_on_attach(bufnr)

					vim.keymap.set("n", "J", "5j", opts("Down 5"))
					vim.keymap.set("n", "K", "5k", opts("Up 5"))
				end,
			})
		end,
	},

	-- file explorer (neo-tree)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		enabled = true,
		cmd = "Neotree",
		keys = {
			{
				"<leader>e",
				function()
					if vim.bo.filetype == "neo-tree" then
						require("neo-tree.command").execute({ action = "close" })
					else
						require("neo-tree.command").execute({ action = "focus", source = "last" })
					end
				end,
				desc = "Explorer NeoTree",
			},
			{
				"<leader>E",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = function()
			local on_move = function(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end

			local events = require("neo-tree.events")

			return {
				sources = { "filesystem", "git_status" },
				auto_clean_after_session_restore = true,
				source_selector = {
					winbar = false,
					content_layout = "center",
				},
				open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
				hide_root_node = true,
				close_if_last_window = true,
				filesystem = {
					bind_to_cwd = false,
					follow_current_file = { enabled = true, leave_dirs_open = true },
					use_libuv_file_watcher = true,
					filtered_items = {
						hide_dotfiles = false,
						always_show = {
							".gitignore",
							".env",
						},
						never_show = {
							".DS_Store",
							".git",
						},
					},
				},
				event_handlers = {
					{ event = events.FILE_MOVED, handler = on_move },
					{ event = events.FILE_RENAMED, handler = on_move },
				},
				window = {
					position = "right",
					width = 50,
					mappings = {
						["<space>"] = "none",
						["O"] = {
							function(state)
								require("lazy.util").open(state.tree:get_node().path, { system = true })
							end,
							desc = "Open file in system",
						},
						-- ["P"] = { "toggle_preview", config = { use_float = false } },
					},
				},
				default_component_configs = {
					indent = {
						with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
				},
			}
		end,
		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			plugins = { spelling = true },

			preset = "helix",
			-- win = {
			-- 	border = require("fedeya.utils.ui").border("CmpBorder"),
			-- 	margin = { 1, 0, 1, 0.6 },
			-- },
			win = {
				-- height = { min = 4, max = 75 },
				-- width = { min = 20, max = 50 },
				border = require("fedeya.utils.ui").border("CmpBorder"),
			},
			-- layout = {
			-- 	height = { min = 4, max = 75 },
			-- 	width = { min = 20, max = 50 },
			-- },
			spec = {
				mode = { "n" },
				{ "<leader>t", group = "terminal" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>q", group = "sessions" },
				{ "<leader>x", group = "diagnostic" },
				{ "<leader>T", group = "tests" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")

			wk.setup(opts)
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Document Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Workspace Diagnostics (Trouble)",
			},
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},

	{
		"petertriho/nvim-scrollbar",
		enabled = false,
		opts = function()
			-- local mocha = require("catppuccin.palettes").get_palette("mocha")
			return {
				hide_if_all_visible = true,
				handlers = {
					gitsigns = true,
					cursor = false,
					diagnostic = true,
					handle = true,
				},
				handle = {
					blend = 50,
					-- color = mocha.lavender,
				},
			}
		end,
	},

	{
		"nvim-pack/nvim-spectre",
		enabled = false,
		keys = {
			{
				"<leader>S",
				function()
					require("spectre").toggle()
				end,
				desc = "Toggle Spectre",
			},
		},
		opts = {},
	},

	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>S",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".git" or name == ".DS_Store"
				end,
			},
			float = {
				padding = 2,
				max_width = 90,
				max_height = 40,
				win_options = {
					winblend = 0,
				},
			},
			delete_to_trash = true,
			keymaps = {
				["<C-s>"] = false,
				["q"] = "actions.close",
			},
		},

		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"-",
				"<cmd>Oil --float<cr>",
				desc = "Open parent directory (Oil)",
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},

			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			dash = {
				enabled = true,
				icon = "-",
				width = "full",
			},
			code = {
				sign = false,
				-- width = "block",
				right_pad = 1,
				left_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
			file_types = {
				"markdown",
				"copilot-chat",
				"Avante",
			},
		},
		ft = {
			"markdown",
			-- "norg",
			-- "org",
			-- "rmd",
			"Avante",
			"AvanteInput",
			"copilot-chat",
		},

		cmd = {
			"RenderMarkdown",
		},
	},

	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"gb",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open Snipe buffer menu",
			},
		},
		opts = {
			ui = {
				position = "center",
				open_win_override = {
					border = "rounded",
				},
			},
			navigate = {
				cancel_snipe = "q",
			},
			sort = "last",
		},
	},
	{
		"nvchad/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			maxkeys = 3,
			position = "top-center",
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = "BufReadPre",
		version = "*",
		enabled = true,
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {},
	},
}
