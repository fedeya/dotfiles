vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- vim.keymap.set("n", "<Enter>", "o<Esc>")

vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set({ "n", "v" }, ";", ":")

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- vim.keymap.set("n", "<Leader>/", ":noh<CR>", { desc = "Clean search highlight" })

-- Yank to clipboard
vim.keymap.set({ "n", "v", "x" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<Leader>Y", '"+y$', { desc = "Copy to clipboard (line)" })

-- Better Paste
vim.keymap.set({ "v", "x" }, "p", "P", { desc = "Paste without yanking", remap = false })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- better scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- close
vim.keymap.set("n", "<leader>qq", "<cmd>q<cr>", { desc = "Close current window" })
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Close all windows" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Tabs
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better vertical movement
vim.keymap.set({ "n", "v" }, "J", "v:count == 0 ? '6gj' : '6j'", { expr = true, silent = true })
vim.keymap.set({ "n", "v" }, "K", "v:count == 0 ? '6gk' : '6k'", { expr = true, silent = true })

-- Terminal
-- vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Enter Normal Mode" })
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

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
