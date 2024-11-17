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
				keymap = {
					accept = false,
				},
			},
			filetypes = {
				markdown = true,
				yaml = true,
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		build = "make tiktoken",
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
		lazy = false,
		version = "*",
		opts = {
			provider = "copilot",
			copilot = {
				model = "claude-3.5-sonnet",
			},
		},
		build = "make",
		dependencies = {
			"MunifTanjim/nui.nvim",
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
