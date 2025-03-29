local function setup_icons()
	-- local colors = {}
	-- colors.markdown = "#1E90FF"
	require("nvim-web-devicons").setup({
		override = {
			lisp = {
				icon = "λ", -- Lambda symbol
				color = "#428850",
				name = "Lisp",
			},
			["README.md"] = {
				icon = "",
				-- color = colors.markdown,
				-- name = "README",
			},
		},
	})
end

return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		setup_icons()
		-- vim.api.nvim_create_autocmd("ColorScheme", {
		-- 	pattern = "*",
		-- 	callback = setup_icons,
		-- })
	end,
}
