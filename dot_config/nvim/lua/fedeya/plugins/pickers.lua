return {
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
					preset = function()
						return vim.o.columns >= 120 and "telescope" or "vertical"
					end,
					layout = {
						-- height = 0.8,
						backdrop = true,
					},
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
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
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
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
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
						layout = {
							preset = "bottom",
						},
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
				"<leader>u",
				function()
					Snacks.picker.undo()
				end,
				desc = "Find Undo",
			},
			{
				"gb",
				function()
					---@diagnostic disable-next-line: missing-fields
					Snacks.picker.buffers({
						layout = {
							preset = "bottom",
						},
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
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
			},
			{
				"<leader>o",
				function()
					vim.fn.jobstart({ "fd", "--type", "d", "-H", "--ignore", "-E", ".git", "--color", "never" }, {
						stdout_buffered = true,
						on_stdout = function(_, data)
							if data then
								local filtered = vim.tbl_filter(function(el)
									return el ~= ""
								end, data)

								local items = {}
								for _, v in ipairs(filtered) do
									table.insert(items, { text = v })
								end

								Snacks.picker.pick({
									source = "directories",
									items = items,
									layout = { preset = "select", reverse = false },
									format = "text",
									confirm = function(picker, item)
										picker:close()
										require("oil").open_float(item.text)
									end,
								})
							end
						end,
					})
				end,
				desc = "Open Directory with Oil",
			},
		},
	},
	-- {
	-- 	"bassamsdata/namu.nvim",
	-- 	opts = {
	-- 		namu_symbols = {
	-- 			enable = true,
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>/",
	-- 			"<cmd>Namu symbols<cr>",
	-- 			desc = "Jump to LSP symbol",
	-- 		},
	-- 	},
	-- },
}
