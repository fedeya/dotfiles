return {
  {
    'ggandor/leap.nvim',
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function()
      require('leap').add_default_mappings()
    end
  },
  {
    "ggandor/flit.nvim",
    keys = function()
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" }
  },
  {
    'phaazon/hop.nvim',
    enabled = false,
    keys = {
      {
        '<leader>l',
        function()
          require('hop').hint_lines()
        end
      },
      {
        'f',
        function()
          local hop = require('hop')

          local directions = require('hop.hint').HintDirection

          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
        end,
        remap = true
      },
      {
        'F',
        function()
          local hop = require('hop')

          local directions = require('hop.hint').HintDirection

          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
        end,
        remap = true
      },
      {
        't',
        function()
          local hop = require('hop')

          local directions = require('hop.hint').HintDirection

          hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        remap = true
      },
      {
        'T',
        function()
          local hop = require('hop')

          local directions = require('hop.hint').HintDirection

          hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })
        end,
        remap = true
      }
    },
    opts = {}
  }
}
