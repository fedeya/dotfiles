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
		config = function()
			require("nvim-surround").setup()
		end,
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
				mode = "v",
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
		opts = { use_default_keymaps = false },
	},
	{
		"gbprod/yanky.nvim",
		opts = {
			highlight = { timer = 150 },
		},
		cmd = { "YankyRingHistory" },
		keys = {
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Yanked Text After Cursor" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Yanked Text Before Cursor" },
			{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
			{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
		},
	},
}
