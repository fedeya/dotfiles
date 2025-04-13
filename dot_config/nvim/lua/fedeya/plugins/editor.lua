return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			settings = {
				save_on_toggle = true,
				-- sync_on_ui_close = true,
			},
		},
		config = function(_, opts)
			local harpoon = require("harpoon")
			local extensions = require("harpoon.extensions")

			harpoon:setup(opts)
			harpoon:extend(extensions.builtins.highlight_current_file())
			-- harpoon:extend(extensions.builtins.navigate_with_number())
		end,
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
				-- {
				-- 	"<Tab>",
				-- 	function()
				-- 		require("harpoon"):list():prev()
				-- 	end,
				-- 	desc = "Harpoon to Previous",
				-- },
				-- {
				-- 	"<S-Tab>",
				-- 	function()
				-- 		require("harpoon"):list():next()
				-- 	end,
				-- 	desc = "Harpoon to Next",
				-- },
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
		enabled = false,
		config = function()
			require("bigfile").setup({
				filesize = 1,
			})
		end,
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		enabled = false,
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
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Explorer NeoTree (git_status)",
			},
			{
				"<leader>E",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
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
					hijack_netrw_behavior = "disabled",
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
						-- expander_collapsed = "",
						-- expander_expanded = "",
						-- expander_highlight = "NeoTreeExpander",
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
			win = {
				border = require("fedeya.utils.ui").border("CmpBorder"),
			},
			spec = {
				mode = { "n" },
				{ "<leader>t", group = "terminal" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>q", group = "sessions" },
				{ "<leader>x", group = "diagnostic" },
				{ "<leader>T", group = "tests" },
				{ "<leader>g", group = "git" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")

			wk.setup(opts)
		end,
	},

	{
		"folke/trouble.nvim",
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
		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
								keys = {
									["<c-t>"] = {
										"trouble_open",
										mode = { "n", "i" },
									},
								},
							},
						},
					},
				})
			end,
		},
	},

	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			hide_if_all_visible = true,
			show_in_active_only = true,
			handlers = {
				gitsigns = true,
				cursor = false,
				diagnostic = true,
				handle = true,
			},
			handle = {
				blend = 0,
				-- color = mocha.lavender,
			},
		},
	},

	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		enabled = false,
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
		lazy = false,
		--- @type oil.SetupOpts
		opts = {
			default_file_explorer = true,
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
				["<C-]>"] = { "actions.select", opts = { vertical = true } },
				["<C-v>"] = { "actions.select", opts = { vertical = true } },
				["q"] = "actions.close",
			},
		},
		config = function(_, opts)
			require("oil").setup(opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,

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
				"codecompanion",
			},
		},
		ft = {
			"markdown",
			"norg",
			"org",
			"rmd",
			"Avante",
			"AvanteInput",
			"copilot-chat",
			"codecompanion",
		},

		cmd = {
			"RenderMarkdown",
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
		"Bekaboo/dropbar.nvim",
		event = "BufReadPost",
		enabled = false,
		opts = {},
	},
	{
		"hat0uma/csvview.nvim",
		---@module "csvview"
		---@type CsvView.Options
		opts = {
			parser = { comments = { "#", "//" } },
			view = {
				display_mode = "border",
			},
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.
				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},
}
