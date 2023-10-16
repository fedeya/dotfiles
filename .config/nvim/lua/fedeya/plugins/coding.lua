return {
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		vscode = true,
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		keys = {
			{
				"<Tab>",
				function()
					if require("copilot.suggestion").is_visible() then
						require("copilot.suggestion").accept()
					else
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
					end
				end,
				desc = "Super Tab",
				mode = "i",
			},
		},
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = false,
				},
			},
			filetypes = {
				markdown = true,
			},
		},
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
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
}
