return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end
      },
    },
    config = function()
      local actions = require('telescope.actions');

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }

      })

      require('telescope').load_extension('projects')
    end
  },
}
