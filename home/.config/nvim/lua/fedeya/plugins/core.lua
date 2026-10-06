return {
  {
    "alexghergh/nvim-tmux-navigation",
    cond = vim.env.HERDR_ENV ~= "1",
    opts = {},
    keys = {
      {
        "<C-h>",
        "<Cmd>NvimTmuxNavigateLeft<CR>",
        desc = "Navigate to left tmux pane",
        mode = { "n", "t" },
      },
      {
        "<C-j>",
        "<Cmd>NvimTmuxNavigateDown<CR>",
        desc = "Navigate to down tmux pane",
        mode = { "n", "t" },
      },
      {
        "<C-k>",
        "<Cmd>NvimTmuxNavigateUp<CR>",
        desc = "Navigate to up tmux pane",
        mode = { "n", "t" },
      },
      {
        "<C-l>",
        "<Cmd>NvimTmuxNavigateRight<CR>",
        desc = "Navigate to right tmux pane",
        mode = { "n", "t" },
      },

      {
        "<c-\\>",
        "<Cmd>NvimTmuxNavigateLastActive<CR>",
        desc = "Navigate to previous tmux pane",
        mode = { "n", "t" },
      },
    },
  },
  {
    "kaar/nvim-herdr-navigator",
    cond = vim.env.HERDR_ENV == "1",
    init = function()
      vim.g.herdr_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-h>", "<Cmd>HerdrNavigateLeft<CR>", desc = "Navigate to left herdr pane", mode = { "n", "t" } },
      { "<C-j>", "<Cmd>HerdrNavigateDown<CR>", desc = "Navigate to down herdr pane", mode = { "n", "t" } },
      { "<C-k>", "<Cmd>HerdrNavigateUp<CR>", desc = "Navigate to up herdr pane", mode = { "n", "t" } },
      { "<C-l>", "<Cmd>HerdrNavigateRight<CR>", desc = "Navigate to right herdr pane", mode = { "n", "t" } },
    },
  },
  {
    "ChmaraX/herdr-nvim",
    cond = vim.env.HERDR_ENV == "1",
    opts = { prefix = "<leader>c" },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      user_commands = false,
      lazy_load = true,
      user_default_options = {
        names = false,
        mode = "background",
        tailwind = "lsp",
        tailwind_opts = {
          update_names = false,
        },
        -- virtualtext_inline = true,
      },
    },
  },
}
