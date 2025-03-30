vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- vim.keymap.set("n", "<Enter>", "o<Esc>")

vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set({ "n", "v" }, ";", ":")

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- vim.keymap.set("n", "<Leader>/", ":noh<CR>", { desc = "Clean search highlight" })

-- Yank to clipboard
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })

-- Better Paste
vim.keymap.set({ "v" }, "p", '"_dP', { desc = "Paste without yanking" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- better scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, remap = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, remap = true })

-- Better window movement
vim.keymap.set({ "n", "v" }, "J", "v:count == 0 ? '5gj' : '5j'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "K", "v:count == 0 ? '5gk' : '5k'", { expr = true, silent = true })

-- Terminal
vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Splits

vim.keymap.set("n", "<Leader>ws", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<Leader>wv", "<C-w>v", { desc = "Split window vertically" })

-- VSCode
if vim.g.vscode then
	-- Commenting VSCode
	vim.keymap.set("x", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("n", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("o", "gc", "<Plug>VSCodeCommentary", { silent = true })
	vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine", { silent = true })
end

-- Neovide
if vim.g.neovide then
	vim.keymap.set({ "n", "v", "x", "o", "i" }, "<D-j>", "<C-n>", { remap = true })
	vim.keymap.set({ "n", "v", "x", "o", "i" }, "<D-k>", "<C-p>", { remap = true })
end
