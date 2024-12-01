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
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
			{
				"<leader>ff",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
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
			local slow_format_filetypes = {}

			local js_formatters = function(buffr)
				if require("conform").get_formatter_info("biome-check", buffr).available then
					return { "biome-check" }
				end

				return { "prettierd", "prettier", stop_after_first = true }
			end

			local eslint_filetypes = {
				javascript = true,
				javascriptreact = true,
				typescript = true,
				typescriptreact = true,
			}

			--- @type conform.setupOpts
			return {
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
				},

				format_on_save = function(bufnr)
					if eslint_filetypes[vim.bo[bufnr].filetype] then
						vim.cmd("silent! EslintFixAll")
					end

					if slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end

					local function on_format(err)
						if err and err:match("timeout$") then
							slow_format_filetypes[vim.bo[bufnr].filetype] = true
						end
					end

					return { timeout_ms = 200, lsp_fallback = true }, on_format
				end,

				format_after_save = function(bufnr)
					if not slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_fallback = true }
				end,

				default_format_opts = {
					timeout_ms = 1000,
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

			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	pattern = "*",
			-- 	callback = function(args)
			-- 		if eslint_filetypes[vim.bo[args.buf].filetype] then
			-- 			vim.cmd("silent! EslintFixAll")
			-- 		end
			--
			-- 		require("conform").format({ bufnr = args.buf })
			-- 	end,
			-- })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
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
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			local border = require("fedeya.utils.ui").border

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
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
				mapping = {
					-- `Enter` key to confirm completion
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl+Space to trigger completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

					-- Navigate between snippet placeholder
					-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
					-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
				},
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
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local lsp_defaults = require("lspconfig").util.default_config

			lsp_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lsp_defaults.capabilities,
				-- cmp
				require("cmp_nvim_lsp").default_capabilities()
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
											{
												"tv\\((([^()]*|\\([^()]*\\))*)\\)",
												"[\"'`]([^\"'`]*).*?[\"'`]",
											},
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
								autoFixOnSave = true,
								codeActionOnSave = {
									enable = true,
									mode = "all",
								},
								useESLintClass = true,
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
