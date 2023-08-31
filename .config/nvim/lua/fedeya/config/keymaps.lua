local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<Enter>', 'o<Esc>')

map('i', 'jk', '<Esc>')

map('n', ';', ':')
map('v', ';', ':')

-- map('n', '<Leader>j', 'J')
map('n', '<Leader>/', ':noh<CR>', { desc = 'Clean search highlight' })

-- Yank to clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = "Copy to clipboard" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

map('n', '<Tab>', '<Cmd>BufferNext<CR>')
map('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>')
map('n', '<M-w>', '<Cmd>BufferClose<CR>')
map('n', '<Leader>qb', '<Cmd>BufferClose<CR>');

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

map('n', 'J', '5j')
map('n', 'K', '5k')
map('v', 'J', '5j')
map('v', 'K', '5k')

-- Accept Inline Suggestion (ex. Copilot) VSCode

if vim.g.vscode then
  map('n', '<Leader>a', "<Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>")
end

-- Commenting VSCode

if vim.g.vscode then
  map('x', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('n', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('o', 'gc', '<Plug>VSCodeCommentary', { silent = true })
  map('n', 'gcc', '<Plug>VSCodeCommentaryLine', { silent = true })
end


-- Copilot
vim.keymap.set('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
