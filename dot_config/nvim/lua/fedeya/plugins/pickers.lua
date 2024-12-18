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
		opts = function()
			local config = require("fzf-lua.config")

			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"

			return {
				"telescope",
				defaults = {
					formatter = "path.dirname_first",
				},
				fzf_colors = true,
				fzf_opts = {
					["--no-scrollbar"] = true,
				},
				files = {
					preview_opts = "hidden",
					file_ignore_patterns = { "node_modules", ".git/", ".cache", "dist", "build", ".DS_Store" },
					silent = true,
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
				"<leader>.",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume last fzf command",
			},
			{
				"<leader>s",
				"<cmd>FzfLua live_grep<cr>",
				desc = "Search",
			},
			{
				"<leader>/",
				"<cmd>FzfLua grep_curbuf<cr>",
				desc = "Search in buffer",
			},
		},
	},
}
