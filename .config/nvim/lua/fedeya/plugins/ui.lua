return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp      = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          enabled = true,
        },
        signature = {
          enabled = false,
        },
        hover = {
          enabled = false
        }
      },
      views    = {
        cmdline_popup = {
          -- border = {
          --   style = border "CmpBorder"
          -- },
        }
      },
      messages = {
        enabled = false
      },
      notify   = {
        enabled = false
        -- view = "cmdline"
      },
      presets  = {
        command_palette = true
      },
      routes   = {
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        }
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = function()
      return {
        symbol = "│",
        draw = {
          animation = require('mini.indentscope').gen_animation.none()
        },
        options = { try_as_border = true },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "NvimTree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    'goolord/alpha-nvim',
    cmd = "Alpha",
    init = function()
      if vim.fn.argc() == 0 then
        require("alpha").setup(require("alpha.themes.startify").config)
      end
    end,
  },
  {
    'rcarriga/nvim-notify',
    event = "VeryLazy",
    enabled = false,
  },
  {
    'romgrk/barbar.nvim',
    event = "VeryLazy",
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = false,
    },
    keys = {
      {
        '<Tab>',
        '<Cmd>BufferNext<CR>',
      },
      {
        '<S-Tab>',
        '<Cmd>BufferPrevious<CR>',
      },
      {
        '<Leader>bp',
        '<Cmd>BufferPick<CR>',
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = {
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },

      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {},
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      extensions = { 'nvim-tree', 'lazy', 'trouble' }
    }
  },
  {
    "folke/drop.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
      require("drop").setup({
        theme = "stars"
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
