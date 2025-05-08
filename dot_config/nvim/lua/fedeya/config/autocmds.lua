local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = augroup("highlightyank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

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

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

autocmd("LspAttach", {
	callback = function(event)
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, {
			desc = "Hover Doc",
			buffer = event.bufnr,
		})

		vim.keymap.set("n", "<leader>a", function()
			vim.lsp.buf.code_action()
		end, {
			desc = "Code Action",
			buffer = event.bufnr,
		})

		vim.keymap.set("n", "<leader>i", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, {
			desc = "Toggle inlay hints",
			buffer = event.bufnr,
		})

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client.name == "eslint" then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = event.buf,
				command = "LspEslintFixAll",
			})
		end
	end,
})
