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
}
