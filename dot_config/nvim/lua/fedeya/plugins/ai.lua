return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = false,
    event = "InsertEnter",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     if require("copilot.suggestion").is_visible() then
      --       require("copilot.suggestion").accept()
      --       return nil
      --     end
      --
      --     return "<tab>"
      --   end,
      --   expr = true,
      --   mode = { "i", "n" }
      -- },
    },
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false,
        },
      },
      filetypes = {
        markdown = true,
        yaml = true,
      },
      -- server = {
      --   type = "binary",
      --   custom_server_filepath = vim.fn.stdpath("data") .. "/mason/bin/copilot-language-server"
      -- }
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    enabled = false,
    opts = {
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          width = 0.38,
        }
      },
      diff_opts = {
        open_in_new_tab = true,
        keep_terminal_focus = true,
      }
    },
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      {
        "<leader>aa",
        "<cmd>ClaudeCodeDiffAccept<cr>",
        desc = "Accept diff",
      },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
          create = "split",
          split = {
            size = 0.2
          }
        },
      },
    },
    keys = {
      -- {
      --   "<c-.>",
      --   function() require("sidekick.cli").focus() end,
      --   desc = "Sidekick Focus",
      --   mode = { "n", "t", "i", "x" },
      -- },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },

  {
    "NickvanDyke/opencode.nvim",
    version = "*",
    enabled = false,
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        events = {
          reload = true,
          permissions = {
            enabled = false
          }
        }
      }
    end,
    keys = {
      {
        "<leader>ae",
        function() require("opencode").ask("@this: ", { submit = true }) end,
        mode = { "n", "x" },
        desc = "Ask opencode",
      },
      {
        "<leader>as",
        function() require("opencode").select() end,
        mode = { "n", "x" },
        desc = "Execute opencode action",
      },
      -- {
      --   "<leader>aa",
      --   function() require("opencode").toggle() end,
      --   mode = { "n", "t", "i" },
      --   desc = "Toggle opencode",
      -- },
      {
        "go",
        function() return require("opencode").operator("@this ") end,
        mode = { "x", "n" },
        expr = true,
        desc = "Add range to opencode",
      },
      {
        "goo",
        function() return require("opencode").operator("@this ") .. "_" end,
        expr = true,
        desc = "Add line to opencode",
      },
      {
        "<S-C-u>",
        function() require("opencode").command("session.half.page.up") end,
        desc = "Scroll opencode up",
      },
      {
        "<S-C-d>",
        function() require("opencode").command("session.half.page.down") end,
        desc = "Scroll opencode down",
      },
    },
  },
}
