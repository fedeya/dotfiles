local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
	vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "fedeya.plugins" },
	},
	defaults = {
		cond = function(plugin)
			if vim.g.vscode then
				return plugin.vscode or false
			end

			return true
		end,
	},
	checker = { enabled = true, notify = false },
	change_detection = {
		notify = false,
	},
	rocks = { hererocks = true },
	install = {
		colorscheme = { "rose-pine" },
	},
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"tohtml",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"zipPlugin",
				"tohtml",
				"tutor",
				"tarPlugin",
			},
		},
	},
})
