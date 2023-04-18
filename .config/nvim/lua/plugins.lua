require("nvim-surround").setup()

local hop = require('hop')

hop.setup()

local directions = require('hop.hint').HintDirection

vim.keymap.set('', '<Leader>w', function()
  hop.hint_words()
end, {remap=true})

vim.keymap.set('', '<Leader>l', function()
  hop.hint_lines()
end, {remap=true})

vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})

vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})

vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})