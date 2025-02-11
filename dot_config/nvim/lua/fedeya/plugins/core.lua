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
		-- ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	-- {
	-- 	"samodostal/image.nvim",
	-- 	enabled = false,
	-- 	dependencies = {
	-- 		"m00qek/baleia.nvim",
	-- 	},
	-- 	event = "BufReadPre",
	-- 	config = function()
	-- 		require("image").setup({
	-- 			render = {
	-- 				foreground_color = true,
	-- 				background_color = true,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"vhyrro/luarocks.nvim",
	-- 	priority = 1001, -- this plugin needs to run before anything else
	-- 	lazy = false,
	-- 	opts = {
	-- 		rocks = { "magick" },
	-- 	},
	-- },
	{

		"3rd/image.nvim",
		enabled = false,
		build = false,
		lazy = true,
		init = function()
			--- autocmd for lazy loading before open a image
			vim.api.nvim_create_autocmd({ "BufReadPre" }, {
				pattern = {
					"*.png",
					"*.jpg",
					"*.jpeg",
					"*.gif",
					"*.bmp",
					"*.webp",
					"*.ico",
				},
				callback = function()
					require("lazy").load({ plugins = { "image.nvim" } })
				end,
			})
		end,
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = false,
				},
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		enabled = false,
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

			{
				"<c-\\>",
				"<cmd><C-U>TmuxNavigatePrevious<cr>",
				desc = "Navigate to previous tmux pane",
			},
		},
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
		event = "BufRead",
		opts = {
			user_default_options = {
				tailwind = "lsp",
				mode = "background",
				-- virtualtext_inline = true,
			},
		},
	},
}
