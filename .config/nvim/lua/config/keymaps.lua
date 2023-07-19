local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<Enter>', 'o<Esc>')

map('i', 'jk', '<Esc>')

map('n', '<Leader>j', 'J')
map('n', '<Leader>/', ':noh<CR>')

map('n', '<Tab>', '<Cmd>BufferNext<CR>')
map('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>')
map('n', '<M-w>', '<Cmd>BufferClose<CR>')

map('n', 'J', '5j')
map('n', 'K', '5k')
map('v', 'J', '5j')
map('v', 'K', '5k')

-- File Explorer

map('n', '<Leader>b', '<Cmd>NvimTreeFocus<CR>')
map('n', '<Leader>e', '<Cmd>NvimTreeToggle<CR>')

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

-- Telescope

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Leader>p', builtin.find_files, {})
vim.keymap.set('n', '<Leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<Leader>gs', builtin.git_status, {})

-- Hop

local hop = require('hop')

local directions = require('hop.hint').HintDirection

vim.keymap.set('', '<Leader>l', function()
  hop.hint_lines()
end, { remap = true })

vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })

vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })

vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })

vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })

-- Copilot
vim.keymap.set('i', '<Tab>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })

-- Toggleterm

map('n', '<Leader>t', '<Cmd>ToggleTerm<CR>')

-- Persistence

vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})
