return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    enabled = true,
    opts = {
      mode = "cursor",
      max_lines = 1,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    opts = {
      opts = {
        enable_rename = false,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    enabled = true,
    commit = "0cfa59947416d14e36a41e6fe4f025abd8760301",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
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
              ["aa"] = { query = "@attribute.outer", desc = "around attribute" },
              ["ia"] = { query = "@attribute.inner", desc = "inside attribute" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            keymaps = {
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
            }
          },
          swap = {
            enable = true,
            keymaps = {
              swap_next = {
                [">K"] = { query = "@block.outer", desc = "Swap next block" },
                [">F"] = { query = "@function.outer", desc = "Swap next function" },
                [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
                [">P"] = { query = "@parameter.outer", desc = "Swap next parameter" },
              },
              swap_previous = {
                ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
                ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
                ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
                ["<P"] = { query = "@parameter.outer", desc = "Swap previous parameter" },
              },
            }
          },
        },
        config = function(_, opts)
          require("nvim-treesitter-textobjects").setup(opts)

          for keymap, mapping in pairs(opts.select.keymaps) do
            if type(mapping) == "table" and mapping.desc then
              vim.keymap.set({ "o", "x" }, keymap, function()
                require("nvim-treesitter-textobjects.select").select_textobject(mapping.query, "textobjects")
              end, { desc = mapping.desc })
            end
          end

          for operation_key, operation in pairs(opts.move.keymaps) do
            for key, mapping in pairs(operation) do
              if type(mapping) == "table" and mapping.desc then
                vim.keymap.set("n", key, function()
                  require("nvim-treesitter-textobjects.move")[operation_key](mapping.query, "textobjects")
                end, { desc = mapping.desc })
              end
            end
          end

          for operation_key, operation in pairs(opts.swap.keymaps) do
            for keymap, mapping in pairs(operation) do
              if type(mapping) == "table" and mapping.desc then
                vim.keymap.set("n", keymap, function()
                  require("nvim-treesitter-textobjects.swap")[operation_key](mapping.query)
                end, { desc = mapping.desc })
              end
            end
          end
        end
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        init = function()
          vim.g.skip_ts_context_commentstring_module = true
        end,
        config = function()
          require("ts_context_commentstring").setup({
            enable_autocmd = false,
          })
        end,
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      local opts = {
        incremental_selection = { enable = true },
        ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "diff",
          "tsx",
          "html",
          "css",
          "json",
          "rust",
          "ron",
          "vim",
          "regex",
          "go",
          "jsdoc",
          "vimdoc",
          "yaml",
          "toml",
          "bash",
          "gitignore",
          "git_config",
          "gitcommit",
          "git_rebase",
          "gitattributes",
          "markdown",
          "markdown_inline",
          -- "dockerfile", # IS EXTREMELY BUGGY
          "graphql",
          "ruby",
          "sql",
          "xml",
          "query",
          "printf",
          "luadoc",
          "luap",
          "jsdoc",
        },
        sync_install = false,
        indent = { enable = true },
      }

      local TS = require("nvim-treesitter")

      TS.setup(opts)

      vim.filetype.add({
        pattern = {
          [".*/waybar/config"] = "jsonc",
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "bash",
          [".*/ghostty/config"] = "bash",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })

      local ts_utils = require("fedeya.utils.treesitter")

      ts_utils.get_installed(true)

      local install = vim.tbl_filter(function(lang)
        return not ts_utils.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        ts_utils.ensure_treesitter_cli(function()
          TS.install(install, { summary = true }):await(function()
            ts_utils.get_installed(true) -- refresh the installed langs
          end)
        end)
      end


      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup("FedeyaTreesitterSetup", { clear = true }),
        callback = function(ev)
          if not ts_utils.have(ev.match) then
            return
          end

          pcall(vim.treesitter.start)

          if ts_utils.have(ev.match, "indents") then
            vim.o.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          -- folds
          -- if ts_utils.have(ev.match, "folds") then
          --   vim.opt.foldexpr = "v:lua.LazyVim.treesitter.foldexpr()"
          -- end
        end,
      })
    end,
  },
}
