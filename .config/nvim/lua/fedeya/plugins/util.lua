return {
	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
			pre_save = function()
				vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" }) -- Required by barbar
			end,
		},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},

	-- discord rich presence
	{
		"andweeb/presence.nvim",
		event = "VeryLazy",
		enabled = false,
		config = function()
			require("presence").setup({
				main_image = "file",
			})
		end,
	},

	{
		"vyfor/cord.nvim",
		enabled = false,
		build = "./build",
		event = "VeryLazy",
		opts = {},
	},

	{
		"antoinemadec/FixCursorHold.nvim",
		lazy = true,
	},

	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},

	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		init = function()
			vim.opt.conceallevel = 2
		end,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/vaults/brain/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/vaults/brain/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			ui = {
				enable = false,
			},
			workspaces = {
				{
					name = "brain",
					path = "~/vaults/brain",
				},
			},

			follow_url_func = function(url)
				-- if is mac open with open command
				if vim.fn.has("mac") == 1 then
					vim.fn.jobstart("open " .. url)
				else
					vim.fn.jobstart("xdg-open " .. url)
				end
			end,
		},
	},
}
