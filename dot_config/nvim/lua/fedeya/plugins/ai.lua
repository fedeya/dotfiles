return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = false,
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
    "copilotlsp-nvim/copilot-lsp",
    enabled = false,
    init = function()
      vim.g.copilot_nes_debounce = 75
      vim.lsp.enable("copilot_ls")
      vim.keymap.set({ "n", "i" }, "<tab>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state

        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
              or (
                require("copilot-lsp.nes").apply_pending_nes()
                and require("copilot-lsp.nes").walk_cursor_end_edit()
              )
          return nil
        else
          -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
          return "<C-i>"
        end
      end, { desc = "Accept Copilot NES suggestion", expr = true })

      vim.keymap.set('n', '<esc>', function()
        ---@diagnostic disable-next-line: empty-block
        if not require('copilot-lsp.nes').clear() then
          return '<esc>'
        end
        vim.keymap.set('n', '<leader>cr', function()
          require('copilot-lsp.nes').restore_suggestion()
          return nil
        end, { desc = 'Restore previous Copilot suggestion', expr = true })
      end)
    end,
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
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    build = "make tiktoken",
    enabled = false,
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    },
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      {
        "<leader>ca",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "AI Chat - Quick Ask",
        mode = { "n", "v" },
      },
      {
        "<Leader>cc",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "AI Chat - Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>cp",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
        mode = { "n", "v" },
      },
    },
    opts = {
      model = "claude-3.5-sonnet",
      show_help = true,
      highlight_headers = false,
      mappings = {
        complete = {
          insert = "",
        },
      },
      window = {
        width = 0.4,
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      require("CopilotChat.integrations.cmp").setup()

      -- local select = require("CopilotChat.select")
      --
      -- opts.selection = select.visual

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup({
        -- extensions = {
        --   avante = {
        --     make_slash_commands = true
        --   }
        -- }
      })
    end
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    enabled = false,
    version = false,
    build = "make",
    --- @type avante.Config
    opts = {
      provider = "copilot",
      auto_suggestions_provider = nil,
      providers = {
        copilot = {
          model = "gpt-4.1",
        }
      },
      disabled_tools = {
        "list_files", -- Built-in file operations
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash", -- Built-in terminal access
      },
      -- claude = {
      -- 	model = "claude-3-7-sonnet-20250219",
      -- },
      file_selector = {
        provider = "snacks",
      },
      selector = {
        provider = "snacks"
      },
      input = {
        provider = "snacks"
      },
      behaviour = {
        auto_suggestions = false,
        -- enable_claude_text_editor_tool_mode = true,
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()

        return hub and hub:get_active_servers_prompt() or ""
      end,
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      windows = {
        width = 38,
        ask = {
          -- floating = true,
        },
      },
      mappings = {
        sidebar = {
          close_from_input = { normal = "q" },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- -- required for Windows users
            -- use_absolute_path = true,
          },
        },
      },
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
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    lazy = false,
    opts = {
      nes = {
        enabled = false
      },
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        }
      }
    },
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     -- if require("sidekick").nes_jump_or_apply() then
      --     --   return -- jumped or applied
      --     -- end
      --
      --     -- if you are using Neovim's native inline completions
      --     -- if vim.lsp.inline_completion.get() then
      --     --   return
      --     --
      --     -- end
      --     if require("copilot.suggestion").is_visible() then
      --       require("copilot.suggestion").accept()
      --     end
      --     --
      --
      --     -- any other things (like snippets) you want to do on <tab> go here.
      --
      --     -- fall back to normal tab
      --     return "<tab>"
      --   end,
      --   mode = { "i", "n" },
      --   expr = true,
      --   desc = "Goto/Apply Next Edit Suggestion",
      -- }
    }
  },

  {
    "NickvanDyke/opencode.nvim",
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
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "tmux",

          tmux = {
            options = "-h -p 40", -- Open in a horizontal split
          }
        },
        events = {
          reload = true,
          permissions = false,
        }
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
  }
}
