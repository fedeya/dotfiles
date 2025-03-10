vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.o.undolevels = 10000
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.smoothscroll = true
vim.o.shiftround = true

vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.conceallevel = 2
vim.o.confirm = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
-- vim.o.pumblend = 10
-- vim.o.pumheight = 10
vim.o.grepprg = "rg --vimgrep"
vim.o.showmode = false
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.timeoutlen = vim.g.vscode and 1000 or 300
vim.o.virtualedit = "block"

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.o.mouse = "a"

vim.opt.updatetime = 200

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

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.splitkeep = "screen"

vim.o.guifont = "JetBrainsMono Nerd Font Mono"

if vim.g.neovide then
	vim.g.neovide_background_color = "#1E1E2E"
	vim.g.neovide_cursor_animation_length = 0
end
