return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"meuter/lualine-so-fancy.nvim",
	},
	enabled = true,
	lazy = false,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = false,
				icons_enabled = true,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {
						"help",
						"spectre_panel",
					},
					winbar = {},
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							local mode_map = {
								["NORMAL"] = "N",
								["INSERT"] = "I",
								["VISUAL"] = "V",
								["V-LINE"] = "V",
								["V-BLOCK"] = "V",
								["COMMAND"] = "C",
								["TERMINAL"] = "T",
							}
							return mode_map[str]
						end,
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1, -- 2 for full path
						symbols = {
							modified = " ",
							readonly = " ",
							-- unnamed = "  ",
						},
					},
					{
						"fancy_diagnostics",
						sources = { "nvim_lsp" },
						symbols = { error = " ", warn = " ", info = " " },
					},
					{ "fancy_searchcount" },
				},
				lualine_x = {
					-- "fancy_lsp_servers",
				},
				lualine_y = {
					{
						"fancy_branch",
						color = { fg = "#FFFFFF" }, -- White
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "lazy" },
		})
	end,
}
