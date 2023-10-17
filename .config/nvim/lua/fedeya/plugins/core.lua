return {
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
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
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"samodostal/image.nvim",
		dependencies = {
			"m00qek/baleia.nvim",
		},
		event = "BufReadPre",
		config = function()
			require("image").setup({
				render = {
					foreground_color = true,
					background_color = true,
				},
			})
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		keys = {
			{
				"<C-h>",
				desc = "Navigate to left tmux pane",
			},
			{
				"<C-j>",
				desc = "Navigate to down tmux pane",
			},
			{
				"<C-k>",
				desc = "Navigate to up tmux pane",
			},
			{
				"<C-l>",
				desc = "Navigate to right tmux pane",
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufRead",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
}
