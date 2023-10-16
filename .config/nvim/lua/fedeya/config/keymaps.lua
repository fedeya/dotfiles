vim.keymap.set("n", "<Enter>", "o<Esc>")

vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set({ "n", "v" }, ";", ":")

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- map('n', '<Leader>j', 'J')
vim.keymap.set("n", "<Leader>/", ":noh<CR>", { desc = "Clean search highlight" })

-- Yank to clipboard
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better window movement
vim.keymap.set({ "n", "v" }, "J", "5j")
vim.keymap.set({ "n", "v" }, "K", "5k")

-- VSCode
if vim.g.vscode then
	-- Accept Inline Suggestion (ex. Copilot) VSCode
	vim.keymap.set("n", "<Leader>a", "<Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>")

	-- Commenting VSCode
	vim.keymap.set("x", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("n", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("o", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine", { silent = true })
end
