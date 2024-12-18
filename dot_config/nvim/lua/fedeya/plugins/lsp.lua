return {
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
		"nvimdev/lspsaga.nvim",
		branch = "main",
		cmd = { "Lspsaga" },
		keys = {
			{
				"gh",
				"<cmd>Lspsaga hover_doc<CR>",
				desc = "Hover Doc",
			},
			{
				"gd",
				"<cmd>Lspsaga goto_definition<CR>",
				desc = "Goto Definition",
			},
			{
				"<leader>a",
				"<cmd>Lspsaga code_action<CR>",
				desc = "Code Action",
				mode = { "n", "v" },
			},
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
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		enabled = false,
		opts = {},
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	{

		"VonHeikemen/lsp-zero.nvim",
		branch = "v4.x",
		lazy = true,
		config = false,
		enabled = false,
		init = function()
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<F3>",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
			{
				"<leader>ff",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
			{
				"<leader>fi",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		opts = function()
			local formatters_by_ft = {
				lua = { "stylua" },
			}

			local prettier_supported = {
				"css",
				"graphql",
				"handlebars",
				"html",
				"javascript",
				"javascriptreact",
				"json",
				"jsonc",
				"less",
				"markdown",
				"markdown.mdx",
				"scss",
				"typescript",
				"typescriptreact",
				"vue",
				"yaml",
			}

			local biome_supported = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"json",
				"jsonc",
				"css",
				"graphql",
			}

			for _, ft in ipairs(prettier_supported) do
				formatters_by_ft[ft] = { "prettierd", "prettier", stop_after_first = true }
			end

			for _, ft in ipairs(biome_supported) do
				if formatters_by_ft[ft] then
					table.insert(formatters_by_ft[ft], 1, "biome-check")
				else
					formatters_by_ft[ft] = { "biome-check" }
				end
			end

			--- @type conform.setupOpts
			return {
				formatters_by_ft = formatters_by_ft,

				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},

				format_after_save = {
					lsp_format = "fallback",
				},

				default_format_opts = {
					timeout_ms = 3000,
					lsp_format = "fallback",
					quiet = true,
				},

				formatters = {
					eslint_d = {
						require_cwd = true,
						cwd = require("conform.util").root_file({
							".eslintrc.js",
							".eslintrc.json",
							".eslintrc.yaml",
							".eslintrc.yml",
							".eslintrc",
						}),
					},
					["biome-check"] = {
						require_cwd = true,
					},
					prettier = {
						inherit = true,
						prepend_args = { "--single-quote", "--config-precedence=prefer-file" },
					},
					prettierd = {
						inherit = true,
						prepend_args = { "--single-quote", "--config-precedence=prefer-file" },
					},
					injected = { options = { ignore_errors = true } },
				},
			}
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "onsails/lspkind.nvim" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local lspkind = require("lspkind")

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Insert }

			local border = require("fedeya.utils.ui").border

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				preselect = cmp.PreselectMode.Item,
				window = {
					completion = {
						side_padding = 1,
						scrollbar = false,
						winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
						border = border("CmpBorder"),
					},
					documentation = {
						border = border("CmpBorder"),
						winhighlight = "Normal:CmpDoc",
					},
				},
				formatting = {
					format = function(entry, item)
						item.menu = nil

						local new_item = lspkind.cmp_format({
							mode = "symbol_text",
							maxwidth = 30,
							ellipsis_char = "...",
						})(entry, item)

						new_item.kind = item.kind .. " "

						return new_item
					end,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{
						name = "lazydev",
						group_index = 0,
					},
					{
						name = "nvim_lsp",
						-- entry_filter = function(entry)
						-- 	return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
						-- end,
					},
					{ name = "luasnip", keyword_length = 2 },
					{ name = "path" },
				}, {
					{ name = "buffer", keyword_length = 3 },
				}),
				mapping = cmp.mapping.preset.insert({
					-- `Enter` key to confirm completion
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl+Space to trigger completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

					-- Navigate between snippet placeholder
					-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
					-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
				}),
			})
		end,
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
		"saghen/blink.cmp",
		version = "v0.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		opts = {
			keymap = {
				preset = "enter",
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = {
					-- different icons of the corresponding source
					Text = "",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "",
					Variable = "",
					Class = "",
					Interface = "",
					Module = "",
					Property = "",
					Unit = "",
					Value = "",
					Enum = "",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "",
					Struct = "",
					Event = "",
					Operator = "",
					TypeParameter = "",
				},
			},
			completion = {
				trigger = {
					show_on_insert_on_trigger_character = false,
					show_on_trigger_character = false,
				},
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
						scrollbar = false,
						-- winhighlight = "Normal:CmpDoc",
					},
					auto_show_delay_ms = 200,
				},
				menu = {
					border = "rounded",
					-- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
					draw = {
						treesitter = "lsp",
						-- columns = {
						-- 	{ "label", "label_description", "kind_icon", gap = 1 },
						-- },
						--
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
						},
						components = {
							label = {
								width = { max = 30 },
							},
							label_description = { width = { max = 20 } },
							kind_icon = {
								text = function(ctx)
									local source, client = ctx.item.source_id, ctx.item.client_id
									local lspName = client and vim.lsp.get_client_by_id(client).name
									if lspName == "emmet_language_server" then
										source = "emmet"
									end

									local sourceIcons =
										{ snippets = "󰩫", buffer = "󰦨", emmet = "", path = "" }
									return (sourceIcons[source] or ctx.kind_icon) .. " "
								end,
							},
						},
					},
				},
			},
			sources = {
				-- completion = {
				-- 	enabled_providers = { "lsp", "path", "snippets", "buffer" },
				-- },
				providers = {
					buffer = {
						min_keyword_length = 4,
						score_offset = -3,
						max_items = 4,
					},
					snippets = {
						min_keyword_length = 2,
						score_offset = -1,
					},
					-- lsp = { fallback_for = { "lazydev" } },
					-- lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- { "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local lsp_defaults = require("lspconfig").util.default_config

			lsp_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lsp_defaults.capabilities,
				-- cmp
				-- require("cmp_nvim_lsp").default_capabilities()
				-- blink
				require("blink.cmp").get_lsp_capabilities()
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP Attach",
				callback = function(event)
					-- local opts = { buffer = event.bufnr }

					-- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {
					-- 	desc = "Hover Doc",
					-- 	buffer = event.bufnr,
					-- })

					vim.keymap.set("n", "<leader>hl", function()
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

			-- lsp.extend_lspconfig({
			-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(),
			-- 	lsp_attach = lsp_attach,
			-- })

			-- lsp.set_server_config({
			-- 	handlers = {
			-- 		["textDocument/hover"] = vim.lsp.with(
			-- 			vim.lsp.handlers.hover,
			-- 			{ border = require("fedeya.utils.ui").border("CmpBorder") }
			-- 		),
			-- 	},
			-- })
			--

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
							-- filetypes = {
							-- 	"javascript",
							-- 	"javascriptreact",
							-- 	"javascript.jsx",
							-- 	"typescript",
							-- 	"typescriptreact",
							-- 	"typescript.tsx",
							-- },
							settings = {
								complete_function_calls = true,
								vtsls = {
									enableMoveToFileCodeAction = true,
									autoUseWorkspaceTsdk = true,
									experimental = {
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
									workingDirectory = { mode = "auto" },
								},
							},
						})
					end,
				},
			})

			for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
				local default_diagnostic_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, context, config)
					if err ~= nil and err.code == -32802 then
						return
					end
					return default_diagnostic_handler(err, result, context, config)
				end
			end

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
}
