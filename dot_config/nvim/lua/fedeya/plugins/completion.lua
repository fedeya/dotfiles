return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    event = "InsertEnter",
    version = false,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      { "onsails/lspkind.nvim" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "saadparwaiz1/cmp_luasnip" },
      { "rafamadriz/friendly-snippets" },
      { "hrsh7th/cmp-cmdline" },
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function()
      local lspkind = require("lspkind")

      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Insert }
      local defaults = require("cmp.config.default")()

      local border = require("fedeya.utils.ui").border

      --- @type cmp.ConfigSchema
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sorting = defaults.sorting,
        preselect = cmp.PreselectMode.Item,
        window = {
          completion = {
            side_padding = 1,
            scrollbar = false,
            -- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
            winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
            border = border("CmpBorder"),
          },
          documentation = {
            border = border("CmpBorder"),
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
          format = function(entry, item)
            item.menu = nil

            local item_with_kind = lspkind.cmp_format({
              mode = "symbol",
              maxwidth = 30,
              ellipsis_char = "...",
            })(entry, item)

            -- item_with_kind.kind = item.kind .. " "

            local item_with_tailwind = require("tailwindcss-colorizer-cmp").formatter(entry, item_with_kind)

            return item_with_tailwind
          end,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 2 },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
        mapping = cmp.mapping.preset.insert({
          -- `Enter` key to confirm completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Ctrl+Space to trigger completion menu
          ["<C-Space>"] = cmp.mapping.complete(),

          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

          -- Navigate between snippet placeholder
          -- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          -- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        }),
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup(opts)

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local completion_capabilities = cmp_nvim_lsp.default_capabilities()

      vim.lsp.config("*", {
        capabilities = completion_capabilities,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    enabled = true,
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      cmdline = {
        enabled = false,
      },
      completion = {
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              }
            }
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            border = 'rounded'
          }
        }
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          codecompanion = {
            'codecompanion',
            'buffer',
          },
        }
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning'
      }
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
    end
  },
}
