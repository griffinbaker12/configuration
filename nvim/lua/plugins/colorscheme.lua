return {
	{
		"zenbones-theme/zenbones.nvim",
		config = function()
			-- vim.o.background = "light"
			-- vim.g.zenbones_compat = 1
			-- vim.cmd.colorscheme("zenbones")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	{
		"sainnhe/gruvbox-material",
		config = function()
			-- vim.o.background = "dark"
			-- vim.g.gruvbox_material_background = "hard"
			-- vim.g.gruvbox_material_ui_contrast = "high"
			-- vim.g.gruvbox_material_better_performance = 1
			-- vim.g.gruvbox_material_enable_italic = 0
			-- vim.g.gruvbox_material_enable_bold = 1
			-- vim.g.gruvbox_material_float_style = "dim"
			-- vim.g.gruvbox_material_disable_italic_comment = 1
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"folke/tokyonight.nvim",
		config = function()
			-- vim.o.background = "light"
			-- vim.cmd([[colorscheme tokyonight-day]])
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("kanagawa").setup({
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
			})
			-- vim.cmd("colorscheme kanagawa-wave")
			-- vim.cmd("colorscheme kanagawa-lotus")
		end,
	},
}
