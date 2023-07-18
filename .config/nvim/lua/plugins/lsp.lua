return {
  {
    'jose-elias-alvarez/null-ls.nvim'
  },
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require('lspsaga').setup({
        symbol_in_winbar = {
          enable = false
        },
        -- keybinds for navigation in lspsaga window
        scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
        -- use enter to open file with definition preview
        definition = {
          edit = "<CR>",
        },
      })
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {                            -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      { 'lukas-reineke/lsp-format.nvim' },
      { 'jose-elias-alvarez/null-ls.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required

      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'rafamadriz/friendly-snippets' },
      { "glepnir/lspsaga.nvim" },
    },
    config = function()
      local lsp = require('lsp-zero').preset({})

      lsp.ensure_installed({
        'tsserver',
        'eslint',
      })

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', opts)
        vim.keymap.set('n', 'gh', '<cmd>Lspsaga hover_doc<CR>', opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<F3>', function() vim.lsp.buf.format() end, opts)
        vim.keymap.set('n', '<leader>a', '<cmd>Lspsaga code_action<CR>', opts)

        if client.supports_method('textDocument/formatting') then
          require('lsp-format').on_attach(client)
        end
      end)

      lsp.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000
        },
        servers = {
          ['null_ls'] = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
        }
      })

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

      local null_ls = require('null-ls')

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier
        }
      })

      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()

      require('luasnip.loaders.from_vscode').lazy_load()

      vim.opt.completeopt = "menu,menuone,noselect"

      cmp.setup({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
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
}
