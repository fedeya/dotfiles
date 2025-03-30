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
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lsp_defaults = require("lspconfig").util.default_config

			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local has_blink, blink = pcall(require, "blink.cmp")

			lsp_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lsp_defaults.capabilities,
				-- cmp
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				-- blink
				has_blink and blink.get_lsp_capabilities() or {}
			)

			vim.diagnostic.config({
				virtual_text = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP Attach",
				callback = function(event)
					-- local opts = { buffer = event.bufnr }

					vim.keymap.set("n", "gh", vim.lsp.buf.hover, {
						desc = "Hover Doc",
						buffer = event.bufnr,
					})

					vim.keymap.set("n", "<leader>a", function()
						vim.lsp.buf.code_action()
					end, {
						desc = "Code Action",
						buffer = event.bufnr,
					})

					vim.keymap.set("n", "<leader>i", function()
						---@diagnostic disable-next-line: missing-parameter
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, {
						desc = "Toggle inlay hints",
						buffer = event.bufnr,
						remap = false,
					})

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client.name == "eslint" then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = event.buf,
							command = "EslintFixAll",
						})
					end
				end,
			})

			local noop = function() end

			require("mason-lspconfig").setup({
				automatic_installation = true,
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
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
					ts_ls = noop,
					emmet_language_server = function()
						require("lspconfig").emmet_language_server.setup({
							init_options = {
								showSuggestionsAsSnippets = true,
							},
						})
					end,
					vtsls = function()
						require("lspconfig").vtsls.setup({
							settings = {
								complete_function_calls = true,
								vtsls = {
									enableMoveToFileCodeAction = false,
									autoUseWorkspaceTsdk = true,
									experimental = {
										maxInlayHintLength = 30,
										completion = {
											enableServerSideFuzzyMatch = true,
										},
									},
								},
								typescript = {
									updateImportsOnFileMove = { enabled = "always" },
									suggest = {
										completeFunctionCalls = true,
									},
									preferences = {
										-- jsxAttributeCompletionStyle = "none",
									},
									inlayHints = {
										enumMemberValues = { enabled = true },
										functionLikeReturnTypes = { enabled = true },
										parameterNames = { enabled = "literals" },
										parameterTypes = { enabled = true },
										propertyDeclarationTypes = { enabled = true },
										variableTypes = { enabled = false },
									},
								},
							},
						})
					end,
					lua_ls = function()
						require("lspconfig").lua_ls.setup({
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										library = {
											vim.env.VIMRUNTIME,
										},
									},
								},
							},
						})
					end,
					tailwindcss = function()
						require("lspconfig").tailwindcss.setup({
							settings = {
								tailwindCSS = {
									experimental = {
										classRegex = {
											-- tailwind variants
											{
												"tv\\((([^()]*|\\([^()]*\\))*)\\)",
												"[\"'`]([^\"'`]*).*?[\"'`]",
											},
											-- react-native-tw (tailwind/tw) fn
											{
												"tailwind|tw\\(([^)]*)\\)",
												"[\"'`]([^\"'`]*).*?[\"'`]",
											},
										},
									},
								},
							},
						})
					end,
					jsonls = function()
						require("lspconfig").jsonls.setup({
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
						})
					end,
					yamlls = function()
						require("lspconfig").yamlls.setup({
							settings = {
								yaml = {
									schemaStore = {
										-- You must disable built-in schemaStore support if you want to use
										-- this plugin and its advanced options like `ignore`.
										enable = false,
										-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
										url = "",
									},
									schemas = require("schemastore").yaml.schemas(),
								},
							},
						})
					end,
					eslint = function()
						require("lspconfig").eslint.setup({
							settings = {
								eslint = {
									format = true,
									workingDirectories = { mode = "auto" },
								},
							},
							-- handlers = {
							-- 	["workspace/configuration"] = function(_, result, ctx)
							-- 		local function lookup_section(table, section)
							-- 			local keys = vim.split(section, ".", { plain = true }) --- @type string[]
							-- 			return vim.tbl_get(table, unpack(keys))
							-- 		end
							--
							-- 		local client_id = ctx.client_id
							-- 		local client = vim.lsp.get_client_by_id(client_id)
							--
							-- 		if not client then
							-- 			vim.notify("No client found", vim.log.levels.ERROR)
							-- 		end
							--
							-- 		if not result.items then
							-- 			return {}
							-- 		end
							--
							-- 		local bufnr = vim.uri_to_bufnr(result.items[1].scopeUri)
							--
							-- 		client.settings.eslint.workingDirectory =
							-- 			{ directory = vim.fs.root(bufnr, { "package.json" }) }
							--
							-- 		vim.cmd([[LspRestart eslint]])
							--
							-- 		local response = {}
							-- 		for _, item in ipairs(result.items) do
							-- 			if item.section then
							-- 				local value = lookup_section(client.settings, item.section)
							-- 				-- For empty sections with no explicit '' key, return settings as is
							-- 				if value == nil and item.section == "" then
							-- 					value = client.settings
							-- 				end
							-- 				if value == nil then
							-- 					value = vim.NIL
							-- 				end
							-- 				table.insert(response, value)
							-- 			end
							-- 		end
							-- 		return response
							-- 	end,
							-- },
						})
					end,
				},
			})

			-- for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			-- 	local default_diagnostic_handler = vim.lsp.handlers[method]
			-- 	vim.lsp.handlers[method] = function(err, result, context, config)
			-- 		if err ~= nil and err.code == -32802 then
			-- 			return
			-- 		end
			-- 		return default_diagnostic_handler(err, result, context, config)
			-- 	end
			-- end

			local mr = require("mason-registry")

			mr:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
		end,
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
		tag = "legacy",
		event = "LspAttach",
		enabled = false,
		opts = {},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
			},
		},
	},
}
