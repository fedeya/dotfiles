return {
  {
    "folke/neodev.nvim",
    enabled = false,
    opts = {
      library = {
        enabled = true
      }
    }
  },
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    keys = {
      {
        'gh',
        '<cmd>Lspsaga hover_doc<CR>',
      },
      {
        'gd',
        '<cmd>Lspsaga goto_definition<CR>'
      },
      {
        '<leader>a',
        '<cmd>Lspsaga code_action<CR>'
      },
      {
        '<leader>d',
        '<cmd>Lspsaga diagnostic_jump_next<CR>',
      }
    },
    config = function()
      require('lspsaga').setup({
        symbol_in_winbar = {
          enable = false
        },
        scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
        ui = {
          border = require('fedeya.utils.ui').border "CmpBorder",
        },
        definition = {
          edit = "<CR>",
        },
      })
    end
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    enabled = false,
    opts = {},
  },
  {

    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = true,
    config = function()
      require('lsp-zero.settings').preset({})
    end
  },
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { "onsails/lspkind.nvim" },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-buffer' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
      require('lsp-zero.cmp').extend()

      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      local lspkind = require('lspkind')

      require('luasnip.loaders.from_vscode').lazy_load()

      local border = require('fedeya.utils.ui').border

      cmp.setup({
        completion = {
          completeopt = "menu,menuone",
        },
        window = {
          completion = {
            side_padding = 1,
            scrollbar = false,
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
            border = border "CmpBorder"
          },
          documentation = {
            border = border "CmpBorder",
            winhighlight = "Normal:CmpDoc",
          },
        },
        formatting = {
          format = function(entry, item)
            item.menu = nil;

            local new_item = lspkind.cmp_format({
              mode = 'symbol_text',
              maxwidth = 30,
              ellipsis_char = '...',
            })(entry, item)

            new_item.kind = item.kind .. " "

            return new_item
          end
        },
        sources = {
          { name = 'path' },
          {
            name = 'nvim_lsp',
            entry_filter = function(entry)
              return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
            end

          },
          { name = 'buffer',  keyword_length = 3 },
          { name = 'luasnip', keyword_length = 2 },
        },
        mapping = {
          -- `Enter` key to confirm completion
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          -- Ctrl+Space to trigger completion menu
          ['<C-Space>'] = cmp.mapping.complete(),

          -- Navigate between snippet placeholder
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = "LspInfo",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'jose-elias-alvarez/null-ls.nvim' },
      { 'b0o/schemastore.nvim' },
      { 'lukas-reineke/lsp-format.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'williamboman/mason.nvim' },
    },
    config = function()
      require('lsp-format').setup {}

      local lsp = require('lsp-zero')

      lsp.ensure_installed({
        'tsserver',
        'eslint',
      })

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<F3>', function() vim.lsp.buf.format() end, opts)

        if client.supports_method('textDocument/formatting') then
          require('lsp-format').on_attach(client)
        end

        client.server_capabilities.semanticTokensProvider = nil
      end)

      lsp.format_on_save({
        format_opts = {
          async = true,
          timeout_ms = 10000
        },
        servers = {
          ['null_ls'] = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
        }
      })


      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      require('lspconfig').tailwindcss.setup({
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                {
                  "tv\\(([^)]*)\\)",
                  "[\"'`]([^\"'`]*).*?[\"'`]"
                }
              }
            }
          }
        }
      })

      require('lspconfig').jsonls.setup {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }

      lsp.setup()

      local null_ls = require('null-ls')

      null_ls.setup({
        debug = false,
        sources = {
          -- null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.eslint_d
        }
      })
    end
  },
}
