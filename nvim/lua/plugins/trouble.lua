return {
	"folke/trouble.nvim",
	dependencies = {
		"dev-icons",
	},
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{ "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble file diagnostics" },
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
	},
}
