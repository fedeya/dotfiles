local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

map('n', '<Enter>', 'o<Esc>')

map('i', 'jk', '<Esc>')

map('n', '<Leader>j', 'J')
map('n', '<Leader>/', ':noh<CR>')

-- Accept Inline Suggestion (ex. Copilot)

map('n', '<Leader>a', "<Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>")
