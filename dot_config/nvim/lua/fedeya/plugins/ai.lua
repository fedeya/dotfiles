return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      {
        "<tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
            return nil
          end

          return "<tab>"
        end,
        expr = true,
        mode = { "i", "n" }
      },
    },
    opts = {
      suggestion = {
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
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
      "j-hui/fidget.nvim",
    },
    enabled = false,
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "AI Chat - Toggle",
        mode = { "n", "v", "x" },
      },
      {
        "<leader>ae",
        function()
          local value = vim.fn.input(
            "AI - Edit Inline: "
          )

          if value ~= "" then
            vim.cmd("CodeCompanion " .. value)
          end

          -- if value ~= "" then
          --   vim.cmd("CodeCompanion " .. value)
          -- end

          -- Snacks.input({
          --     prompt = "AI - Edit Inline",
          --     win = {
          --       relative = "cursor",
          --       col = 0,
          --       row = 1,
          --       width = 40,
          --       -- height = 3,
          --       -- b = {
          --       --   completion = true,
          --       -- },
          --       -- bo = {
          --       -- filetype = "codecompanion",
          --       -- }
          --     },
          --   },
          -- function(input)
          -- if input ~= nil and input ~= "" then
          --   vim.cmd("CodeCompanion " .. input)
          -- end
          -- end
          -- )
        end,
        desc = "AI Chat - Edit Inline",
        mode = { "v", "x", "n" },
      },
      -- {
      -- "<leader>ac",
      -- function()
      -- Snacks.input({
      --     prompt = "AI - Quick Ask",
      --     win = {
      --       -- height = 3,
      --       wo = {
      --         wrap = true
      --       },
      --       b = {
      --         completion = true,
      --       },
      --       bo = {
      --         filetype = "codecompanion",
      --       }
      --     },
      --   },
      --   function(input)
      --     if input ~= nil and input ~= "" then
      --       vim.cmd("CodeCompanion " .. input)
      --     end
      --   end
      -- )
      -- end,
      -- desc = "AI Chat - Quick Ask",
      -- mode = { "n" }
      -- },
      {
        "<leader>ai",
        "<cmd>CodeCompanionActions<cr>",
        desc = "AI Actions",
        mode = { "n", "v", "x" },
      },
      {
        "<LocalLeader>a",
        "<cmd>CodeCompanionChat Add<CR>",
        desc = "Add code to a chat buffer",
        mode = { "v" },
      }
    },
    opts = function()
      return {
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true
            }
          },
        },
        display = {
          chat = {
            window = {
              width = 80
            }
          }
        },
        adapters = {
          -- openrouter_claude = function()
          --   return require("codecompanion.adapters").extend("openai_compatible", {
          --     env = {
          --       url = "https://openrouter.ai/api",
          --       api_key = "cmd: op read op://personal/OpenRouter/credential --no-newline",
          --       chat_url = "/v1/chat/completions",
          --     },
          --     schema = {
          --       model = {
          --         default = "anthropic/claude-sonnet-4",
          --       },
          --     },
          --   })
          -- end
          --
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  -- ANTHROPIC_API_KEY = "cmd: op read op://personal/Anthropic/credential --no-newline",
                  ANTHROPIC_API_KEY = function()
                    local cache_file = "/tmp/anthropic_api_key_cache"
                    local f = io.open(cache_file, "r")
                    if f then
                      local key = f:read("*a")
                      f:close()
                      if key and key ~= "" then
                        return key
                      end
                    end
                    local key = vim.fn.trim(vim.fn.system("op read op://personal/Anthropic/credential --no-newline"))
                    f = io.open(cache_file, "w")
                    if f then
                      f:write(key)
                      f:close()
                      os.execute("chmod 600 " .. cache_file)
                    end
                    return key
                  end
                },
                defaults = {
                  model = "opus"
                }
              })
            end
          }
        },
        interactions = {
          chat = {
            adapter = {
              name = "claude_code",
            },
            roles = {
              user = "Fedeya"
            }
          },
          inline = {
            adapter = {
              name = "claude_code",
            }
          },
          cmd = {
            adapter = {
              name = "claude_code",
            }
          },
        },
        opts = {
          language = "Español",
        }
      }
    end,
    config = function(_, opts)
      local codecompanion = require("codecompanion")

      codecompanion.setup(opts)

      require("fedeya.utils.spinner"):init()
    end
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
    "NickvanDyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "e-cal/opencode-tmux.nvim",
        opts = {
          options = "-h -p 40",
          focus = false,
          auto_close = false,
          allow_passthrough = false,
          find_sibling = true,
        },
      },
    },
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
      {
        "<leader>aa",
        function() require("opencode").toggle() end,
        mode = { "n", "t", "i" },
        desc = "Toggle opencode",
      },
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
