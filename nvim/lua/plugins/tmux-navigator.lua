return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
		vim.g.tmux_navigator_no_mappings = 1
		vim.g.tmux_navigator_disable_when_zoomed = 1
		vim.g.tmux_navigator_preserve_zoom = 1
		vim.g.tmux_navigator_disable_netrw_workaround = 1
		vim.g.tmux_navigator_save_on_switch = 2

		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<M-h>", ":<C-U>TmuxNavigateLeft<CR>", opts)
		vim.keymap.set("n", "<M-j>", ":<C-U>TmuxNavigateDown<CR>", opts)
		vim.keymap.set("n", "<M-k>", ":<C-U>TmuxNavigateUp<CR>", opts)
		vim.keymap.set("n", "<M-l>", ":<C-U>TmuxNavigateRight<CR>", opts)
		vim.keymap.set("n", "<M-w>\\", ":<C-U>TmuxNavigatePrevious<CR>", opts)
	end,
}
