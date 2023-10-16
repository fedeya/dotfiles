local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<Enter>', 'o<Esc>')

map('i', 'jk', '<Esc>')

vim.keymap.set({ 'n', 'v' }, ';', ':')

-- map('n', '<Leader>j', 'J')
map('n', '<Leader>/', ':noh<CR>', { desc = 'Clean search highlight' })

-- Yank to clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = "Copy to clipboard" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better window movement
vim.keymap.set({ 'n', 'v' }, 'J', '5j')
vim.keymap.set({ 'n', 'v' }, 'K', '5k')

-- VSCode
if vim.g.vscode then
  -- Accept Inline Suggestion (ex. Copilot) VSCode
  map('n', '<Leader>a', "<Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>")

  -- Commenting VSCode
  map('x', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('n', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('o', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('n', 'gcc', '<Plug>VSCodeCommentaryLine', { silent = true })
end
