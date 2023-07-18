return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<Leader>p', builtin.find_files, {})
      vim.keymap.set('n', '<Leader>f', builtin.live_grep, {})
      vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})

      require('telescope').load_extension('fzf')
    end
  },
}
