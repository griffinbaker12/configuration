return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			local border = "#547998"
			require("tokyonight").setup({
				style = "night",
				terminal_colors = true,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
				},
				on_colors = function(colors)
					colors.border = border
				end,
			})
			-- vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			-- Basic configuration
			vim.g.material_transparent_background = 0
			vim.g.gruvbox_material_foreground = "mix"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_float_style = "bright"
			vim.g.gruvbox_material_statusline_style = "material"
			vim.g.gruvbox_material_cursor = "auto"

			-- Disable italics to match your Tokyo Night setup
			vim.g.gruvbox_material_enable_italic = 0
			vim.g.gruvbox_material_disable_italic_comment = 1

			-- Better performance
			vim.g.gruvbox_material_better_performance = 1

			-- Set as active colorscheme
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
}
