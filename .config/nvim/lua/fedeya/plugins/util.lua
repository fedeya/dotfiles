return {
  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = function()
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" }) -- Required by barbar
      end,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- discord rich presence
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
      require("presence").setup({
        main_image = "file",
      })
    end,
  },

  {
    'vyfor/cord.nvim',
    build = './build',
    event = 'VeryLazy',
    opts = {}
  },

  {
    "antoinemadec/FixCursorHold.nvim",
    lazy = true,
  },

  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}
