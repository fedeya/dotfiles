return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = false,
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        -- function()
        --   require("neo-tree.command").execute({ toggle = true, dir = require("utils").get_root() })
        -- end,
        '<cmd>Neotree toggle focus filesystem right<cr>',
        desc = "Explorer NeoTree (root dir)",
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
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
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
            enable = true
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
  }
}
