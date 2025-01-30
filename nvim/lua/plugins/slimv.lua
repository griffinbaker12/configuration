return {
	{
		"kovisoft/slimv",
		config = function()
			vim.g.slimv_swank_cmd =
				'! tmux new-window -d -n REPL-SBCL "sbcl --load ~/.local/share/nvim/lazy/slimv/slime/start-swank.lisp"'
			vim.g.slimv_repl_split = 2
			vim.g.slimv_repl_split_right = 0
			vim.g.slimv_preferred = "sbcl"
			vim.g.lisp_rainbow = 1

			vim.keymap.set("n", "<Leader>e", ":call slimv#Eval()<CR>", { silent = true })
			vim.keymap.set("n", "<Leader>d", ":call slimv#SendDefun()<CR>", { silent = true })
			vim.keymap.set("n", "<Leader>b", ":call slimv#SendBuffer()<CR>", { silent = true })
			vim.keymap.set("n", "<Leader>c", ":call slimv#ConnectServer()<CR>", { silent = true })
		end,
	},
	{
		"gpanders/nvim-parinfer",
		ft = { "lisp", "scheme", "racket", "clojure" },
	},
}
