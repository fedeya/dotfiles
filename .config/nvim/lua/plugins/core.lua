return {
  {
    'mbbill/undotree',
  },
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
      }
    end
  },
  {
    'tpope/vim-repeat'
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },
  {
    'andweeb/presence.nvim',
    config = function()
      require('presence').setup({
        main_image = 'file',
      })
    end
  },
  {
    'nvim-tree/nvim-web-devicons'
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin'
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {},
          lualine_x = { 'filetype' },
          lualine_y = {},
          lualine_z = { 'location' },
        },
      })
    end
  },
  {
    'romgrk/barbar.nvim',
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = false,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = false
          }
        }
      })
    end,
  },
  {
    'rcarriga/nvim-notify'
  },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    'goolord/alpha-nvim',
    event = "VimEnter",
    config = function()
      require 'alpha'.setup(require('alpha.themes.startify').config)
    end
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
}
