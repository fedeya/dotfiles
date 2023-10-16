return {
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        '<leader>qb',
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete Buffer'
      }
    }
  },

  -- marks plugin
  {
    'chentoast/marks.nvim',
    event = "VeryLazy",
    config = function()
      require('marks').setup({
        default_mappings = true,
      })
    end
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    keys = {
      {
        '<leader>e',
        '<cmd>NvimTreeToggle<cr>',
      },
      {
        '<leader>b',
        '<cmd>NvimTreeFocus<cr>',
      }
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("nvim-tree")
        end
      end
    end,
    config = function()
      require("nvim-tree").setup {
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { "^.git$", "^.DS_Store$" }
        },
        auto_reload_on_write = true,
        view = {
          width = 40,
          side = "right",
          debounce_delay = 15,
        },
        renderer = {
          indent_markers = {
            enable = false
          }
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 'J', '5j', opts("Down 5"))
          vim.keymap.set('n', 'K', '5k', opts("Up 5"))
        end
      }
    end,
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
}
