return {
  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>u',
        '<cmd>UndotreeToggle<cr>',
      }
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
    }
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = "MarkdownPreview",
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'samodostal/image.nvim',
    dependencies = {
      'm00qek/baleia.nvim'
    },
    event = "BufReadPre",
    config = function()
      require('image').setup {
        render = {
          foreground_color = true,
          background_color = true,
        }
      }
    end
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true
  },
  {
    'ahmedkhalf/project.nvim',
    event = "VeryLazy",
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
        border = require('fedeya.utils.ui').border 'CmpBorder',
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
    event = "VeryLazy",
    config = function()
      require('marks').setup({
        default_mappings = true,
      })
    end
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        "<Leader>j",
        "<cmd>TSJToggle<cr>",
        desc = "Join Toggle",
      },
    },
    opts = { use_default_keymaps = false },
  },
  {
    'christoomey/vim-tmux-navigator',
    event = "VeryLazy"
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
    'tpope/vim-repeat',
    event = "VeryLazy"
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = "BufRead",
    opts = {
      user_default_options = {
        tailwind = true
      }
    }
  },
  {
    'andweeb/presence.nvim',
    event = "VeryLazy",
    config = function()
      require('presence').setup({
        main_image = 'file',
      })
    end
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true
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
        },
        filetypes = {
          markdown = true
        }
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    'numToStr/Comment.nvim',
    keys = {
      {
        'gcc',
        desc = 'Comment line',
      },
      {
        'gc',
        mode = 'v',
        desc = 'Comment operator',
      }
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },
}
