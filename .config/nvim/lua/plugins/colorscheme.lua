return {
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'catppuccin'
    }
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        term_colors = true,
        no_bold = true,
        integrations = {
          cmp = true,
          lsp_saga = true,
          nvimtree = true,
          treesitter = true,
          leap = true,
          gitsigns = true,
          hop = true,
          barbar = true,
          mason = true,
          alpha = true,
          telescope = {
            enabled = true,
          },
        },
        color_overrides = {
          mocha = {
            base = "#191927",
            crust = '#12121c',
            mantle = '#14141f'
          },
        }
      })

      vim.cmd.colorscheme 'catppuccin'
    end
  }
}
