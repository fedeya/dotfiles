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
		"olimorris/codecompanion.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>cc",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "AI Chat - Toggle",
			},
			{
				"<leader>ca",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CodeCompanion " .. input)
					end
				end,
				desc = "AI Chat - Quick Ask",
				mode = { "n", "v", "x" },
			},
		},
		opts = function()
			return {
				adapters = {
					copilot = require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.5-sonnet",
							},
						},
					}),
				},
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			}
		end,
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
		"yetone/avante.nvim",
		event = "VeryLazy",
		enabled = true,
		version = false,
		lazy = false,
		--- @type avante.Config
		opts = {
			provider = "claude",
			auto_suggestions_provider = "claude-haiku",
			copilot = {
				model = "claude-3.7-sonnet",
			},
			-- claude = {
			-- 	model = "claude-3-7-sonnet-20250219",
			-- },
			file_selector = {
				provider = "snacks",
			},
			behaviour = {
				auto_suggestions = false,
				auto_set_keymaps = false,
				enable_claude_text_editor_tool_mode = true,
			},
			windows = {
				width = 38,
				ask = {
					-- floating = true,
				},
			},
			mappings = {
				ask = "<leader>ca",
				refresh = "<leader>cr",
				edit = "<leader>ce",
				sidebar = {
					close_from_input = { normal = "q" },
				},
			},
		},
		keys = function(_, keys)
			local opts = require("lazy.core.plugin").values(
				require("lazy.core.config").spec.plugins["avante.nvim"],
				"opts",
				false
			)

			local mappings = {
				{
					opts.mappings.ask,
					function()
						require("avante.api").ask()
					end,
					desc = "avante: ask",
					mode = { "n", "v" },
				},
				{
					opts.mappings.refresh,
					function()
						require("avante.api").refresh()
					end,
					desc = "avante: refresh",
					mode = { "n", "v" },
				},
				{
					opts.mappings.edit,
					function()
						require("avante.api").edit()
					end,
					desc = "avante: edit",
					mode = { "n", "v" },
				},
				{
					"<leader>cc",
					"<cmd>AvanteToggle<CR>",
					desc = "avante: toggle",
					mode = { "n", "v" },
				},
				{
					"<leader>cs",
					function()
						require("avante.api").get_suggestion():suggest()
					end,
					desc = "avante: suggest",
					mode = { "n", "v" },
				},
			}

			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)

			return vim.list_extend(mappings, keys)
		end,
		build = "make",
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
