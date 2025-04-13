vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.nu = true
vim.o.relativenumber = true

-- vim.o.cmdheight = 1

vim.o.completeopt = "menu,menuone,noselect"

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.undolevels = 10000
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.smoothscroll = true
vim.o.shiftround = true

vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.conceallevel = 2
vim.o.confirm = true

vim.o.hlsearch = false
vim.o.incsearch = true
-- vim.o.pumblend = 10
-- vim.o.pumheight = 10
vim.o.grepprg = "rg --vimgrep"
vim.o.showmode = false
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.timeoutlen = vim.g.vscode and 1000 or 300
vim.o.virtualedit = "block"

vim.o.termguicolors = true

vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.ruler = false
vim.o.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.o.mouse = "a"

vim.o.updatetime = 200
-- vim.o.winborder = "rounded"
vim.o.foldcolumn = "0"
vim.o.laststatus = 3
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.splitkeep = "screen"

vim.o.guifont = "JetBrainsMono Nerd Font"

if vim.g.neovide then
	vim.g.neovide_background_color = "#1E1E2E"
	vim.g.neovide_cursor_animation_length = 0
end

vim.diagnostic.config({
	virtual_text = true,
})
