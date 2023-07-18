return {
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },
  {
    'phaazon/hop.nvim',
    config = function()
      require('hop').setup()
    end
  }
}
