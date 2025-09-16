return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      {
        "<Tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
          end
        end,
        desc = "Super Tab",
        mode = "i",
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
      copilot_model = "gpt-4o-copilot",
      filetypes = {
        markdown = true,
        yaml = true,
      },
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
      {
        "Davidyz/VectorCode",
        version = "*",
        build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    enabled = true,
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
          vectorcode = {
            opts = {
              add_tool = true
            }
          }
        },
        -- adapters = {
        --   openrouter_claude = function()
        --     return require("codecompanion.adapters").extend("openai_compatible", {
        --       env = {
        --         url = "https://openrouter.ai/api",
        --         api_key = "cmd: op read op://personal/OpenRouter/credential --no-newline",
        --         chat_url = "/v1/chat/completions",
        --       },
        --       schema = {
        --         model = {
        --           default = "anthropic/claude-sonnet-4",
        --         },
        --       },
        --     })
        --   end
        -- },
        strategies = {
          chat = {
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
            roles = {
              user = "Fedeya"
            }
          },
          inline = {
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            }
          },
          cmd = {
            adapter = {
              name = "copilot",
              model = "gpt-4.1"
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
}
