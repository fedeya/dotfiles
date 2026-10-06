return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    enabled = true,
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    dependencies = {
      { "kevinhwang91/promise-async" },
    },
  },
}
