vim.g.mapleader = " "

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.opt.cmdheight = 1

vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

vim.o.guifont = "JetBrainsMono Nerd Font Mono"

if vim.g.neovide then
	vim.g.neovide_background_color = "#1E1E2E"
	vim.g.neovide_cursor_animation_length = 0
end
