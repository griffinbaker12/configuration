return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				lisp = {
					icon = "λ", -- Lambda symbol
					color = "#428850",
					name = "Lisp",
				},
			},
		})
	end,
}
