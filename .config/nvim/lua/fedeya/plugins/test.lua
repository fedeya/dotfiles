return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
			"thenbe/neotest-playwright",
		},
		cmd = "Neotest",
		keys = {
			{
				"<leader>Ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle summary",
			},

			{
				"<leader>Tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest",
			},

			{
				"<leader>Tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},

			{
				"<leader>Tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run test file",
			},

			{
				"<leader>TT",
				function()
					require("neotest").run.run(vim.loop.cwd())
				end,
				desc = "Run all tests in project",
			},

			{
				"<leader>Ta",
				function()
					require("neotest").playwright.attachment()
				end,
				desc = "Launch attachment",
			},

			{
				"<leader>To",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},

			{
				"<leader>TO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},

			{
				"<laeder>TS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
		},
		opts = function()
			return {
				adapters = {
					require("neotest-vitest"),
					require("neotest-playwright").adapter({
						enable_dynamic_test_discovery = true,
						persist_project_selection = true,
					}),
				},
				consumers = {
					playwright = require("neotest-playwright.consumers").consumers,
				},
			}
		end,
	},
}
