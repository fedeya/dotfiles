return {
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				"<cmd>UndotreeToggle<cr>",
				desc = "Toggle undotree",
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Document Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Workspace Diagnostics (Trouble)",
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		-- cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		build = function()
			vim.fn["mkdp#util#install"]()
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
		"ahmedkhalf/project.nvim",
		enabled = false,
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({})
		end,
	},
	{
		"Wansmer/treesj",
		keys = {
			{
				"<Leader>j",
				"<cmd>TSJToggle<cr>",
				desc = "Join Toggle",
			},
		},
		opts = { use_default_keymaps = false },
	},
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
	},
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
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
	{
		"andweeb/presence.nvim",
		event = "VeryLazy",
		config = function()
			require("presence").setup({
				main_image = "file",
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
}
