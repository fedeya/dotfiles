return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{
			"<leader>tt",
			function()
				if vim.bo.filetype == "toggleterm" and vim.v.count == 0 then
					vim.cmd("ToggleTermToggleAll")
				else
					vim.cmd("exe v:count1 . 'ToggleTerm'")
				end
			end,
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
		shade_terminals = false,
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
