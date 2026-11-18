return {
	"sainnhe/sonokai",
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		vim.g.sonokai_disable_italic_comment = 1
		vim.g.sonokai_enable_italic = 0
		vim.g.sonokai_better_performance = 1
		-- Active tab label: black background, light text (sonokai makes it pink).
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "sonokai",
			callback = function()
				vim.api.nvim_set_hl(0, "TabLineSel", { ctermfg = 250, ctermbg = 16, fg = "#e2e2e3", bg = "#000000" })
			end,
		})
		vim.cmd.colorscheme("sonokai")
	end,
}
