return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 40,
          side = "right"
        },
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 'J', '5j', opts("Down 5"))
          vim.keymap.set('n', 'K', '5k', opts("Up 5"))
        end
      }
    end,
  }
}
