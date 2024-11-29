return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
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
}
