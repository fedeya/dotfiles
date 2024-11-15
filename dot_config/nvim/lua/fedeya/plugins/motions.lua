return {
  {
    {
      "folke/flash.nvim",
      vscode = true,
      opts = {
        modes = {
          char = {
            jump_labels = true,
            multi_line = false,
          },
        },
      },
      keys = {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        -- {
        -- 	"S",
        -- 	mode = { "n", "o", "x" },
        -- 	function()
        -- 		require("flash").treesitter()
        -- 	end,
        -- 	desc = "Flash Treesitter",
        -- },
        {
          "r",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "R",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
        {
          "<c-s>",
          mode = { "c" },
          function()
            require("flash").toggle()
          end,
          desc = "Toggle Flash Search",
        },
      },
    },
  },
  {
    "ggandor/leap.nvim",
    vscode = true,
    enabled = false,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "ggandor/flit.nvim",
    vscode = true,
    enabled = false,
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "phaazon/hop.nvim",
    enabled = false,
    keys = {
      {
        "<leader>l",
        function()
          require("hop").hint_lines()
        end,
      },
      {
        "f",
        function()
          local hop = require("hop")

          local directions = require("hop.hint").HintDirection

          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        remap = true,
      },
      {
        "F",
        function()
          local hop = require("hop")

          local directions = require("hop.hint").HintDirection

          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        remap = true,
      },
      {
        "t",
        function()
          local hop = require("hop")

          local directions = require("hop.hint").HintDirection

          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        remap = true,
      },
      {
        "T",
        function()
          local hop = require("hop")

          local directions = require("hop.hint").HintDirection

          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        remap = true,
      },
    },
    opts = {},
  },
}
