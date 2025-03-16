return {
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.o.background = "dark"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_disable_italic_comment = 1
			vim.g.gruvbox_material_enable_italic = 0
			vim sourced.cmd.colorscheme("gruvbox-material")
		end,
	},
}
