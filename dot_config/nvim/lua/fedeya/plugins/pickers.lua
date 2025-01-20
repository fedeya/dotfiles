return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		enabled = false,
		keys = {
			{
				"<leader>p",
				function()
					require("telescope.builtin").find_files({
						hidden = true,
						file_ignore_patterns = { "node_modules", ".git/", ".cache", "dist", "build" },
					})
				end,
				desc = "Find files",
			},
			-- {
			-- 	"<leader>p",
			-- 	"<cmd>Telescope frecency workspace=CWD<cr>",
			-- 	desc = "Find files",
			-- },
			{
				"<leader>s",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Search",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				desc = "Search in buffer",
			},
		},
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			-- {
			-- 	"nvim-telescope/telescope-frecency.nvim",
			-- 	config = function()
			-- 		require("telescope").load_extension("frecency")
			-- 	end,
			-- },
		},
		config = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.sources.telescope").open(...)
			end

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_with_trouble,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					frecency = {
						ignore_patterns = { "node_modules", ".git/", ".cache", "dist", "build" },
						workspace = "CWD",
						default_workspace = "CWD",
						show_filter_column = { "FOO" },
					},
				},

				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--sortr=modified" },
					},
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		enabled = false,
		opts = function()
			local config = require("fzf-lua.config")

			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"

			return {
				"telescope",
				defaults = {
					formatter = "path.dirname_first",
					file_ignore_patterns = { "node_modules", ".git/", ".cache", "dist", "build", ".DS_Store" },
				},
				fzf_colors = true,
				fzf_opts = {
					["--no-scrollbar"] = true,
				},
				files = {
					winopts = {
						preview = { hidden = "hidden" },
					},
					cwd_prompt = false,
					-- winopts = {
					-- 	preview = {
					-- 		hidden = true,
					-- 	},
					-- },
					git_icons = true,
					-- winopts = {
					-- 	preview = {
					-- 		hidden = true,
					-- 	},
					-- },
					-- no_header = true,
				},
				winopts = {
					width = 0.8,
					height = 0.8,
					row = 0.5,
					col = 0.5,
					preview = {
						scrollchars = { "|", "" },
					},
				},
			}
		end,
		keys = {
			{
				"<leader>p",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find files",
			},
			{
				"<leader>o",
				function()
					-- rose pine colors
					local rose = "\x1b[38;2;235;188;186m" -- #ebbcba
					local love = "\x1b[38;2;235;111;146m" -- #eb6f92
					local reset = "\x1b[0m"

					require("fzf-lua").fzf_exec("fd --type d -H --ignore -E .git", {
						fzf_opts = {
							["--preview"] = "fd --base-directory {} --max-depth 1 --color always",
							["--header"] = ":: <"
								.. rose
								.. "ctrl-r"
								.. reset
								.. "> to "
								.. love
								.. "Open root dir"
								.. reset,
						},
						actions = {
							default = function(selected)
								require("oil").open_float(selected[1])
							end,
							["ctrl-r"] = {
								fn = function()
									require("oil").open_float(vim.fn.getcwd())
								end,
							},
						},
					})
				end,
				desc = "Open Directory with Oil",
			},
			{
				"<leader>.",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume last fzf command",
			},
			{
				"<leader>b",
				function()
					require("fzf-lua").buffers({
						sort_mru = true,
						sort_lastused = true,
					})
				end,
			},
			{
				"<leader>s",
				"<cmd>FzfLua live_grep<cr>",
				desc = "Search",
			},
			{
				"<leader>/",
				function()
					require("fzf-lua").grep_curbuf({
						winopts = {
							winblend = 10,
							height = 0.2,
							width = 0.4,
							backdrop = 90,
							preview = { hidden = "hidden" },
						},
					})
				end,
				desc = "Search in buffer",
			},
		},
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			picker = {
				ui_select = true,
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
				layout = {
					reverse = true,
					preset = function()
						return vim.o.columns >= 120 and "telescope" or "vertical"
					end,
				},
				sources = {
					files = {
						hidden = true,
					},
				},
			},
		},
		keys = {
			{
				"<leader>p",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>s",
				function()
					Snacks.picker.grep()
				end,
				desc = "Search",
			},
			{
				"<leader>.",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume last snack picker",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git log",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.lines()
				end,
				desc = "Search in buffer",
			},
			{
				"<leader>b",
				function()
					---@diagnostic disable-next-line: missing-fields
					Snacks.picker.buffers({
						win = {
							input = {
								keys = {
									["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
								},
							},
						},
					})
				end,
				desc = "Buffers",
			},
			{
				"<leader>o",
				function()
					vim.fn.jobstart({ "fd", "--type", "d", "-H", "--ignore", "-E", ".git" }, {
						stdout_buffered = true,
						on_stdout = function(_, data)
							Snacks.picker.select(data, {
								prompt = "Open Directory",
								kind = "dir",
							}, function(dir)
								require("oil").open_float(dir)
							end)

							--- @type snacks.picker.finder.Item[]
							-- local items = {}
							--
							-- for _, dir in ipairs(data) do
							-- 	table.insert(items, {
							-- 		--- @type snacks.picker.finder.Item
							-- 		text = dir,
							-- 	})
							-- end
							--
							-- Snacks.picker.pick({
							-- 	finder = function(opts, filter)
							-- 		return items
							-- 	end,
							-- 	-- cwd = vim.fn.getcwd(),
							-- 	confirm = function(_, item)
							-- 		require("oil").open_float(item.text)
							-- 	end,
							-- 	preview = function()
							-- 		return false
							-- 	end,
							-- })
						end,
					})
				end,
			},
		},
	},
}
