return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ "onsails/lspkind.nvim" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "hrsh7th/cmp-cmdline" },
			{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
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
						-- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel",
						winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
						border = border("CmpBorder"),
					},
					documentation = {
						border = border("CmpBorder"),
						-- winhighlight = "Normal:CmpDoc",
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					expandable_indicator = true,
					format = function(entry, item)
						item.menu = nil

						local item_with_kind = lspkind.cmp_format({
							mode = "symbol",
							maxwidth = 30,
							ellipsis_char = "...",
						})(entry, item)

						-- item_with_kind.kind = item.kind .. " "

						local item_with_tailwind = require("tailwindcss-colorizer-cmp").formatter(entry, item_with_kind)

						return item_with_tailwind
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

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		enabled = false,
		opts_extend = { "sources.default" },
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
					Snippet = "󰩫",
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
					create_undo_point = false,
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
						treesitter = { "lsp" },
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
}
