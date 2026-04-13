return {
  {
    "alexghergh/nvim-tmux-navigation",
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
