local hey = 3
print(vim.bo.filetype)

local test = "hey"
print("test", test)

return {
	"folke/zen-mode.nvim",
	opts = {
		plugins = {
			tmux = { enabled = true },
		},
	},
}
