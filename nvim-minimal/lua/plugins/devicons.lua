-- oil's dependency (it refers to this spec by name, "dev-icons").
return {
	"nvim-tree/nvim-web-devicons",
	name = "dev-icons",
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				lisp = {
					icon = "λ", -- Lambda symbol
					color = "#428850",
					name = "Lisp",
				},
				["README.md"] = {
					icon = "",
					name = "README",
				},
			},
		})
	end,
}
