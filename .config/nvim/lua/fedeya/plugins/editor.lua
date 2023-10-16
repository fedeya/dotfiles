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

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    enabled = false,
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

  -- file explorer (neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = true,
    cmd = "Neotree",
    keys = {
      {
        '<leader>e',
        function()
          if vim.bo.filetype == 'neo-tree' then
            require('neo-tree.command').execute({ action = "close" })
          else
            require('neo-tree.command').execute({ action = "focus", source = "last" })
          end
        end
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      auto_clean_after_session_restore = true,
      source_selector = {
        winbar = true,
        content_layout = "center",
      },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      hide_root_node = true,
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          always_show = {
            ".gitignore",
            ".env"
          },
          never_show = {
            ".DS_Store",
            ".git",
          }
        }
      },
      window = {
        position = "right",
        mappings = {
          ["<space>"] = "none",
          ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem right', true) end,
          ['b'] = function() vim.api.nvim_exec('Neotree focus buffers right', true) end,
          ['g'] = function() vim.api.nvim_exec('Neotree focus git_status right', true) end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
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
