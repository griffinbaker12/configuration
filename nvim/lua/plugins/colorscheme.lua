return {
	-- {
	-- 	"zenbones-theme/zenbones.nvim",
	-- 	config = function()
	-- 		vim.o.background = "light"
	-- 		vim.g.zenbones_compat = 1
	-- 		vim.cmd.colorscheme("zenbones")
	-- 	end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			integrations = {
	-- 				-- Your existing integrations here
	-- 			},
	-- 			highlight_overrides = {
	-- 				all = function(colors)
	-- 					return {
	-- 						["@keyword"] = { style = { "bold" } },
	-- 						["@keyword.function"] = { style = { "bold" } },
	-- 						["@keyword.return"] = { style = { "bold" } },
	-- 						["@keyword.operator"] = { style = { "bold" } },
	-- 					}
	-- 				end,
	-- 			},
	-- 		})
	-- 		vim.cmd.colorscheme("catppuccin-mocha")
	-- 	end,
	-- },
	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	config = function()
	-- 		require("onedark").setup({
	-- 			style = "darker",
	-- 			code_style = {
	-- 				comments = "none",
	-- 				keywords = "none",
	-- 				functions = "none",
	-- 				strings = "none",
	-- 				variables = "none",
	-- 			},
	-- 		})
	-- 		require("onedark").load()
	-- 	end,
	-- },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	config = function()
	-- 		vim.o.background = "light"
	-- 		vim.g.gruvbox_material_background = "hard"
	-- 		vim.g.gruvbox_material_ui_contrast = "high"
	-- 		vim.g.gruvbox_material_better_performance = 1
	-- 		vim.g.gruvbox_material_enable_italic = 0
	-- 		vim.g.gruvbox_material_enable_bold = 1
	-- 		vim.g.gruvbox_material_float_style = "dim"
	-- 		vim.g.gruvbox_material_disable_italic_comment = 1
	-- 		vim.cmd.colorscheme("gruvbox-material")
	-- 	end,
	-- },
	-- {
	-- 	"shaunsingh/nord.nvim",
	-- 	config = function()
	-- 		vim.g.nord_bold = true
	-- 		vim.cmd.colorscheme("nord")
	-- 	end,
	-- },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			styles = {
	-- 				keywords = { bold = true },
	-- 				functions = { bold = true },
	-- 			},
	-- 		})
	-- 		vim.o.background = "dark"
	-- 		vim.cmd([[colorscheme tokyonight-storm]])
	-- 	end,
	-- },
	-- {
	-- 	"maxmx03/solarized.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	---@type solarized.config
	-- 	opts = {},
	-- 	config = function(_, opts)
	-- 		vim.o.termguicolors = true
	-- 		vim.o.background = "light"
	-- 		require("solarized").setup(opts)
	-- 		vim.cmd.colorscheme("solarized")
	-- 	end,
	-- },
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("kanagawa").setup({
	-- 			statementStyle = { bold = true },
	-- 			colors = {
	-- 				theme = {
	-- 					all = {
	-- 						ui = {
	-- 							bg_gutter = "none",
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			commentStyle = { italic = false },
	-- 			keywordStyle = { italic = false },
	-- 			overrides = function(colors)
	-- 				return {
	-- 					Statement = { bold = true },
	-- 					Keyword = { bold = true },
	-- 				}
	-- 			end,
	-- 		})
	-- 		vim.o.background = "dark"
	-- 		vim.cmd("colorscheme kanagawa-wave")
	-- 	end,
	-- },
	-- {
	-- 	"gmr458/vscode_modern_theme.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("vscode_modern").setup({
	-- 			cursorline = true,
	-- 			transparent_background = false,
	-- 		})
	-- 		vim.cmd.colorscheme("vscode_modern")
	-- 	end,
	-- },
	"Mofiqul/vscode.nvim",
	config = function()
		require("vscode").setup({
			style = "dark",
			transparent = false,
			italic_comments = true,
			disable_nvimtree_bg = true,
		})
		vim.cmd.colorscheme("vscode")
	end,
}
