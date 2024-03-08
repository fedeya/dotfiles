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
			-- {
			-- 	"gh",
			-- 	"<cmd>Lspsaga hover_doc<CR>",
			-- 	desc = "Hover Doc",
			-- },
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
				"<leader>d",
				"<cmd>Lspsaga diagnostic_jump_next<CR>",
				desc = "Diagnostic Jump Next",
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
		branch = "v3.x",
		lazy = true,
		config = false,
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
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			local slow_format_filetypes = {}

			local js_formatters = { { "prettierd", "prettier" } }

			local eslint_filetypes = {
				javascript = true,
				javascriptreact = true,
				typescript = true,
				typescriptreact = true,
			}

			require("conform").setup({
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

					return { timeout_ms = 200, lsp_fallback = true, async = true }, on_format
				end,

				format_after_save = function(bufnr)
					if not slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_fallback = true }
				end,

				format = {
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
					prettier = {
						inherit = true,
						prepend_args = { "--single-quote", "--config-precedence=prefer-file" },
					},
					prettierd = {
						inherit = true,
						prepend_args = { "--single-quote", "--config-precedence=prefer-file" },
					},
				},
			})

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
			local lsp_zero = require("lsp-zero")

			lsp_zero.extend_cmp()

			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

			local border = require("fedeya.utils.ui").border

			cmp.setup({
				completion = {
					completeopt = "menu,menuone",
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
				sources = {
					{ name = "path" },
					{
						name = "nvim_lsp",
						entry_filter = function(entry)
							return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
						end,
					},
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip", keyword_length = 2 },
				},
				mapping = {
					-- `Enter` key to confirm completion
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl+Space to trigger completion menu
					["<C-Space>"] = cmp.mapping.complete(),

					-- Navigate between snippet placeholder
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
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
			local lsp = require("lsp-zero")

			lsp.extend_lspconfig()

			lsp.set_server_config({
				handlers = {
					["textDocument/hover"] = vim.lsp.with(
						vim.lsp.handlers.hover,
						{ border = require("fedeya.utils.ui").border("CmpBorder") }
					),
				},
			})

			lsp.on_attach(function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)

				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)

				vim.keymap.set("n", "gh", function()
					vim.lsp.buf.hover()
				end, opts)

				vim.keymap.set("n", "<F3>", function()
					vim.lsp.buf.format()
				end, opts)

				-- client.server_capabilities.semanticTokensProvider = nil
			end)

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
					"taplo", -- TOML LSP
				},
				handlers = {
					lsp.default_setup,
					tsserver = lsp.noop, -- disabled for typescript-tools
					lua_ls = function()
						require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
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

			require("typescript-tools").setup({
				settings = {
					jsx_close_tag = {
						enable = true,
					},
				},
			})
		end,
	},
}
