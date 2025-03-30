return {
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		enabled = false,
		keys = {
			{
				"<leader>u",
				"<cmd>UndotreeToggle<cr>",
				desc = "Toggle undotree",
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		-- ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"alexghergh/nvim-tmux-navigation",
		opts = {},
		keys = {
			{
				"<C-h>",
				"<Cmd>NvimTmuxNavigateLeft<CR>",
				desc = "Navigate to left tmux pane",
			},
			{
				"<C-j>",
				"<Cmd>NvimTmuxNavigateDown<CR>",
				desc = "Navigate to down tmux pane",
			},
			{
				"<C-k>",
				"<Cmd>NvimTmuxNavigateUp<CR>",
				desc = "Navigate to up tmux pane",
			},
			{
				"<C-l>",
				"<Cmd>NvimTmuxNavigateRight<CR>",
				desc = "Navigate to right tmux pane",
			},

			{
				"<c-\\>",
				"<Cmd>NvimTmuxNavigateLastActive<CR>",
				desc = "Navigate to previous tmux pane",
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
		opts = {
			user_commands = false,
			lazy_load = true,
			user_default_options = {
				names = false,
				mode = "background",
				tailwind = "lsp",
				tailwind_opts = {
					update_names = false,
				},
				-- virtualtext_inline = true,
			},
		},
	},
}
