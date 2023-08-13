local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

return {
  {
    'mbbill/undotree',
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({})
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      window = {
        border = border 'CmpBorder',
        margin = { 1, 0, 1, 0.6 }
      },
      layout = {
        height = { min = 4, max = 75 },
        width = { min = 20, max = 50 }
      }
    }
  },
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        default_mappings = true,
      })
    end
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<Leader>j", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    'christoomey/vim-tmux-navigator'
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
  { "lukas-reineke/indent-blankline.nvim" },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
}
