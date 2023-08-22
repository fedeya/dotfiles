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
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
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
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      })
    end
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
  }
}
