return {
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  {
    'tpope/vim-fugitive',
    enabled = false,
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  }
}
