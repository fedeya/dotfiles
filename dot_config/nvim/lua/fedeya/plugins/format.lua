return {
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
				python = { "black" },
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
}
