return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
      },
      {
        'windwp/nvim-autopairs',
        opts = {
          check_ts = true,
        }
      },
      {
        'windwp/nvim-ts-autotag'
      },
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        autotag = {
          enable = true,
          enable_close_on_slash = false
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false
        },
        incremental_selection = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ak"] = { query = "@block.outer", desc = "around block" },
              ["ik"] = { query = "@block.inner", desc = "inside block" },
              ["ac"] = { query = "@class.outer", desc = "around class" },
              ["ic"] = { query = "@class.inner", desc = "inside class" },
              ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
              ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
              ["af"] = { query = "@function.outer", desc = "around function " },
              ["if"] = { query = "@function.inner", desc = "inside function " },
              ["al"] = { query = "@loop.outer", desc = "around loop" },
              ["il"] = { query = "@loop.inner", desc = "inside loop" },
              ["aa"] = { query = "@parameter.outer", desc = "around argument" },
              ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
            }
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]k"] = { query = "@block.outer", desc = "Next block start" },
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
            },
            goto_next_end = {
              ["]K"] = { query = "@block.outer", desc = "Next block end" },
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
            },
            goto_previous_start = {
              ["[k"] = { query = "@block.outer", desc = "Previous block start" },
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
            },
            goto_previous_end = {
              ["[K"] = { query = "@block.outer", desc = "Previous block end" },
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              [">K"] = { query = "@block.outer", desc = "Swap next block" },
              [">F"] = { query = "@function.outer", desc = "Swap next function" },
              [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
              [">P"] = { query = "@parameter.outer", desc = "Swap next parameter" }
            },
            swap_previous = {
              ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
              ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
              ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
              ["<P"] = { query = "@parameter.outer", desc = "Swap previous parameter" }
            },
          },
        },
        ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "rust",
          "vim",
          "regex",
          "go",
          "jsdoc",
          "vimdoc",
          "yaml",
          "toml",
          "bash",
          "gitignore",
          "markdown",
          "markdown_inline",
        },
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
