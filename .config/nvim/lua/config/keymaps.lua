local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', 'jk', '<Esc>', { noremap = true })

map('n', '<Leader>j', 'J', { noremap = true })
map('n', '<Leader>/', ':noh<CR>', { noremap = true })

-- Accept Inline Suggestion (ex. Copilot)

map('n', '<Leader>a', "<Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>")
