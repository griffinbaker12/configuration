return {
	"folke/trouble.nvim",
	dependencies = {
		"dev-icons",
	},
	opts = {
		focus = true,
	},
	keys = {
		{ "<leader>xo", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{ "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble file diagnostics" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{
			"]x",
			function()
				---@diagnostic disable-next-line: missing-fields, missing-parameter
				require("trouble").next({ skip_groups = true, jump = true })
			end,
		},
		{
			"[x",
			function()
				---@diagnostic disable-next-line: missing-fields, missing-parameter
				require("trouble").prev({ skip_groups = true, jump = true })
			end,
		},
	},
}
