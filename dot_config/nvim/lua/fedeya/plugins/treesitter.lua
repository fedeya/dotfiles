return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		enabled = false,
		opts = {
			mode = "cursor",
			max_lines = 1,
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		opts = {
			opts = {
				enable_rename = false,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				init = function()
					vim.g.skip_ts_context_commentstring_module = true
				end,
				config = function()
					require("ts_context_commentstring").setup({
						enable_autocmd = false,
					})
				end,
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				incremental_selection = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["ak"] = { query = "@block.outer", desc = "around block" },
							["ik"] = { query = "@block.inner", desc = "inside block" },
							["ac"] = { query = "@class.outer", desc = "around class" },
							["ic"] = { query = "@class.inner", desc = "inside class" },
							["a?"] = { query = "@conditional.outer", desc = "around conditional" },
							["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
							["af"] = { query = "@function.outer", desc = "around function " },
							["if"] = { query = "@function.inner", desc = "inside function " },
							["al"] = { query = "@loop.outer", desc = "around loop" },
							["il"] = { query = "@loop.inner", desc = "inside loop" },
							["aa"] = { query = "@parameter.outer", desc = "around argument" },
							["ia"] = { query = "@parameter.inner", desc = "inside argument" },
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]k"] = { query = "@block.outer", desc = "Next block start" },
							["]f"] = { query = "@function.outer", desc = "Next function start" },
							["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
						},
						goto_next_end = {
							["]K"] = { query = "@block.outer", desc = "Next block end" },
							["]F"] = { query = "@function.outer", desc = "Next function end" },
							["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
						},
						goto_previous_start = {
							["[k"] = { query = "@block.outer", desc = "Previous block start" },
							["[f"] = { query = "@function.outer", desc = "Previous function start" },
							["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
						},
						goto_previous_end = {
							["[K"] = { query = "@block.outer", desc = "Previous block end" },
							["[F"] = { query = "@function.outer", desc = "Previous function end" },
							["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							[">K"] = { query = "@block.outer", desc = "Swap next block" },
							[">F"] = { query = "@function.outer", desc = "Swap next function" },
							[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
							[">P"] = { query = "@parameter.outer", desc = "Swap next parameter" },
						},
						swap_previous = {
							["<K"] = { query = "@block.outer", desc = "Swap previous block" },
							["<F"] = { query = "@function.outer", desc = "Swap previous function" },
							["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
							["<P"] = { query = "@parameter.outer", desc = "Swap previous parameter" },
						},
					},
				},
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"diff",
					"tsx",
					"html",
					"css",
					"json",
					"rust",
					"ron",
					"vim",
					"regex",
					"go",
					"jsdoc",
					"vimdoc",
					"yaml",
					"toml",
					"bash",
					"gitignore",
					"git_config",
					"gitcommit",
					"git_rebase",
					"gitattributes",
					"markdown",
					"markdown_inline",
					"dockerfile",
					"graphql",
					"ruby",
					"sql",
					"xml",
					"query",
					"printf",
					"luadoc",
					"luap",
					"jsonc",
					"jsdoc",
				},
				sync_install = false,
				highlight = {
					enable = true,
				},
				indent = { enable = true },
			})

			vim.filetype.add({
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "bash",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})
		end,
	},
}
