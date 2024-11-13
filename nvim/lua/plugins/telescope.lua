return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"plenary",
		"dev-icons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "List open buffers" })
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "List vim help tags" })
		vim.keymap.set("n", "<leader>ls", "<cmd>Telescope live_grep<cr>")
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
		vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
		vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
		vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
		vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
		vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
	end,
}
