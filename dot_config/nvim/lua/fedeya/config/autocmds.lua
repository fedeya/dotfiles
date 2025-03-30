-- local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- autocmd("TextYankPost", {
--   desc = "Highlight yanked text",
--   group = augroup("highlightyank", { clear = true }),
--   pattern = "*",
--   callback = function()
--     vim.highlight.on_yank({ higroup = "IncSearch" })
--   end,
-- })

-- Set filetype ruby for files that are not recognized by vim
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		-- Podfiles
		"*.podspec",
		"Podfile",

		-- Fastlane
		"Appfile",
		"Fastfile",
		"Matchfile",
		"Deliverfile",
		"Snapfile",
		"Supplyfile",
		"Gymfile",
		"Frameitfile",
		"Pemfile",
		"Sighfile",
		"Rapidfile",
		"Scanfile",
		"Cerfile",
		"Provisioningfile",
	},
	command = "set filetype=ruby",
})

-- Set filetpe terraform
autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		"*.tf",
		"*.tfvars",
	},
	command = "set filetype=terraform",
})

-- Open help files in a vertical split
autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		".env.*",
		".env",
	},
	command = "set filetype=sh",
})
