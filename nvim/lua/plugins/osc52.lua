return {
	{
		"ojroques/nvim-osc52",
		config = function()
			-- Set up OSC52 as the clipboard provider
			vim.g.clipboard = {
				name = "OSC 52",
				copy = {
					["+"] = require("vim.ui.clipboard.osc52").copy,
					["*"] = require("vim.ui.clipboard.osc52").copy,
				},
				paste = {
					["+"] = require("vim.ui.clipboard.osc52").paste,
					["*"] = require("vim.ui.clipboard.osc52").paste,
				},
			}
		end,
	},
}
