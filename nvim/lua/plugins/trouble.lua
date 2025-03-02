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
	config = function(_, opts)
		require("trouble").setup(opts)
		vim.cmd([[
            highlight! link TroubleNormal QuickFixLine
            highlight! link TroubleNormalNC TroubleNormal
            
            highlight! link TroubleText Normal
            highlight! link TroubleTextNC TroubleText
            
            highlight! link TroubleSelected QuickFixLine
            highlight! link TroubleSelectedNC TroubleSelected
            
            highlight! link TroubleSelectedError TroubleSelected
            highlight! link TroubleSelectedWarning TroubleSelected
            highlight! link TroubleSelectedHint TroubleSelected
            highlight! link TroubleSelectedInformation TroubleSelected
            
            highlight! link TroublePreview Visual
        ]])
	end,
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
