return {
  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = function()
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" }) -- Required by barbar
      end,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".env"] = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- init = function()
    -- 	vim.opt.conceallevel = 2
    -- end,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
      .. vim.fn.expand("~")
      .. "/vaults/brain/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/vaults/brain/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      ui = {
        enable = false,
      },
      legacy_commands = false,
      workspaces = {
        {
          name = "brain",
          path = "~/vaults/brain",
        },
      },
      picker = {
        name = "snacks.pick",
      },

      follow_url_func = function(url)
        -- if is mac open with open command
        if vim.fn.has("mac") == 1 then
          vim.fn.jobstart("open " .. url)
        else
          vim.fn.jobstart("xdg-open " .. url)
        end
      end,
    },
  },

  {
    "alker0/chezmoi.vim",
    enabled = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    enabled = true,
    lazy = false,
    keys = {
      {
        "<leader>qb",
        function() Snacks.bufdelete() end,
        desc = "Close Buffer",
      },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
      {
        "<C-/>",
        function() Snacks.terminal() end,
        desc = "Toggle Terminal",
        mode = "n"
      },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
      {
        "<leader>gg",
        function() Snacks.lazygit() end,
        desc = "Toggle lazygit",
      },
      {
        "<leader>gB",
        function() Snacks.gitbrowse() end,
        desc = "Browse GitHub",
      },
    },
    ---@type snacks.Config
    opts = {
      bigfile = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
      terminal = {
        win = {
          position = "float",
          border = "rounded",
        },
      },
      scroll = {
        enabled = false,

        animate = {
          duration = { step = 5, total = 200 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
      },
      image = {
        enabled = true,
        doc = {
          enabled = false,
          inline = false,
          conceal = function(lang, type)
            return lang == "markdown"
          end,
        },
      },
      indent = {
        terminal = {
          -- win = {
          -- border = "rounded",
          -- },
        },
        enabled = true,
        animate = { enabled = false },
        scope = { enabled = true },
        -- chunk = {
        -- enabled = true,
        -- hl = "SnacksIndentScope",
        -- },
      },
      notifier = {
        enabled = false,
        style = "compat",
        top_down = false,
      },
      dashboard = {
        preset = {
          keys = {
            { action = ":lua require('fff').find_files()", desc = " Find file", icon = " ", key = "f" },
            { action = ":ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = ":lua Snacks.picker.recent()", desc = " Recent files", icon = " ", key = "r" },
            { action = ":lua require('fff').live_grep()", desc = " Find text", icon = " ", key = "g" },
            {
              action = ':lua require("persistence").load()',
              desc = " Restore Session",
              icon = " ",
              section = "session",
              key = "s",
            },
            { action = ":Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = ":qa", desc = " Quit", icon = " ", key = "q" },
          },
        },
      },
      words = { enabled = true, modes = { "n", "c" }, debounce = 200 },
    },
  },

  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
  {
    'vuciv/golf',
    cmd = "Golf",
  },
  {
    "mistricky/codesnap.nvim",
    tag = "v2.0.0-beta.17",
    opts = {},
    enabled = false,
    cmd = {
      "CodeSnap",
      "CodeSnapSave",
      "CodeSnapHighlight",
      "CodeSnapSaveHighlight",
    },
  },
}
