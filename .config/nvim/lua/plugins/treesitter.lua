return {
  {
    'windwp/nvim-ts-autotag'
  },
  {
    'windwp/nvim-autopairs',
    opts = {
      check_ts = true,
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require('nvim-treesitter.configs')

      configs.setup({
        autotag = {
          enable = true,
        },
        ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "css", "json", "markdown",
          "markdown_inline" },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = { enable = true }
      })
    end
  }
}
