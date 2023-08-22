return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    cmd = "Telescope",
    keys = {
      {
        '<leader>p',
        function()
          require('telescope.builtin').find_files({
            hidden = true,
            file_ignore_patterns = { 'node_modules', '.git/' },
          })
        end
      },
      {
        '<leader>f',
        function()
          require('telescope.builtin').live_grep()
        end
      },
      {
        '<leader>fb',
        function()
          require('telescope.builtin').buffers()
        end
      },
      {
        '<leader>fh',
        function()
          require('telescope.builtin').help_tags()
        end
      },
      {
        '<leader>gs',
        function()
          require('telescope.builtin').git_status()
        end
      },
      {
        '<leader>fp',
        '<cmd>Telescope projects<CR>'
      }
    },
    dependencies = {
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