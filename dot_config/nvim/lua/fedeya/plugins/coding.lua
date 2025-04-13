return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		vscode = true,
		keys = {
			{
				"cs",
				desc = "Change Surrounding",
			},
			{
				"ds",
				desc = "Delete Surrounding",
			},
			{
				"ys",
				desc = "Add Surrounding",
			},
			{
				"S",
				desc = "Add Surrounding",
				mode = "v",
			},
		},
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		keys = {
			{
				"gcc",
				desc = "Comment line",
			},
			{
				"gc",
				mode = { "n", "v" },
				desc = "Comment operator",
			},
		},
		opts = function()
			return {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
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
		opts = {
			use_default_keymaps = false,
			max_join_length = 300,
		},
	},
	{
		"gbprod/yanky.nvim",
		opts = {
			highlight = { timer = 150 },
		},
		cmd = { "YankyRingHistory" },
		keys = {
			{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
			{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
		},
	},

	{
		"jidn/vim-dbml",
		ft = "dbml",
	},
}
