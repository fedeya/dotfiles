return {

  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    cmd = { "Lspsaga" },
    keys = {
      {
        "gd",
        "<cmd>Lspsaga goto_definition<CR>",
        desc = "Goto Definition",
      },
      -- {
      -- 	"<leader>a",
      -- 	"<cmd>Lspsaga code_action<CR>",
      -- 	desc = "Code Action",
      -- 	mode = { "n", "v" },
      -- },
      {
        "<leader>r",
        "<cmd>Lspsaga rename mode=n<CR>",
        desc = "Rename",
      },
      {
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        desc = "Diagnostic Jump Next",
      },
      {
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        desc = "Diagnostic Jump Prev",
      },
    },
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
        },
        scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
        ui = {
          border = require("fedeya.utils.ui").border("CmpBorder"),
        },
        rename = {
          in_select = false,
          keys = {
            quit = "<ESC>",
          },
        },
        definition = {
          edit = "<CR>",
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "pmizio/typescript-tools.nvim",
    lazy = true,
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "tailwindcss",
        "eslint",
        "rust_analyzer",
        "yamlls",
        "html",
        "cssls",
        "vtsls", -- Vscode typescript
        "taplo", -- TOML LSP
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "gruntwork-io/terragrunt-ls",
    ft = "hcl",
    config = function()
      local terragrunt_ls = require("terragrunt-ls")

      terragrunt_ls.setup({
        cmd_env = {
          TG_LS_LOG = vim.fn.expand("/tmp/terragrunt-ls.log"),
        },
      })

      if terragrunt_ls.client then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "hcl",
          callback = function()
            vim.lsp.buf_attach_client(0, terragrunt_ls.client)
          end,
        })
      end
    end,
  },
  {
    "folke/neodev.nvim",
    enabled = false,
    opts = {
      library = {
        enabled = true,
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "LspAttach",
    opts = {}
  },

  {
    "yioneko/nvim-vtsls",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "lazy.nvim",          words = { "LazyVim" } },
      },
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "LspAttach",
    opts = {
      picker = "snacks"
    },
    keys = {
      {
        "ga",
        function()
          require("tiny-code-action").code_action()
        end,
        desc = "Code Action",
        mode = { "n", "x", "v" },
      },
    }
  }
}
