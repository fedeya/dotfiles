return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{
			"<leader>tt",
			"<cmd>ToggleTerm<cr>",
			desc = "Toggle terminal",
		},
		{
			"<leader>tf",
			"<cmd>ToggleTerm direction=float<cr>",
			desc = "Toggle terminal (float)",
		},
		{
			"<leader>tv",
			"<cmd>ToggleTerm direction=vertical size=80<cr>",
			desc = "Toggle terminal (vertical)",
		},
		{
			"<leader>th",
			"<cmd>ToggleTerm direction=horizontal size=20<cr>",
			desc = "Toggle terminal (horizontal)",
		},
	},
	opts = {
		highlights = {
			FloatBorder = { link = "CmpBorder" },
		},
		on_create = function()
			vim.opt.foldcolumn = "0"
			vim.opt.signcolumn = "no"
		end,
		direction = "float",
		float_opts = {
			border = "rounded",
		},
	},
}
