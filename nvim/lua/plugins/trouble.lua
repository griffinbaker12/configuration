return {
	"folke/trouble.nvim",
	dependencies = {
		"dev-icons",
	},
	opts = {
		mode = "workspace_diagnostics",
		focus = true,
		use_diagnostic_signs = true,
	},
	keys = {
		{ "<leader>xo", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{ "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble file diagnostics" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{
			"]x",
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
		},
		{
			"[x",
			function()
				require("trouble").prev({ skip_groups = true, jump = true })
			end,
		},
	},
}
