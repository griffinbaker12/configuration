return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"plenary",
		"dev-icons",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
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
			extensions = {
				fzf = {},
			},
		})
		telescope.load_extension("fzf")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

		local exclude_dirs = {
			"node_modules", -- JavaScript dependencies
			".next", -- Next.js build directory
			"__pycache__", -- Python cache files
			".git", -- Git repository data
			"build", -- Common build output directory
			"dist", -- Common distribution directory
			".venv", -- Python virtual environment
			"venv", -- Another common virtual env name
			".pytest_cache", -- pytest cache directory
			".mypy_cache", -- mypy cache directory
		}

		local find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", ".env*" }
		for _, dir in ipairs(exclude_dirs) do
			table.insert(find_command, "--glob")
			table.insert(find_command, "!" .. dir .. "/*")
		end

		table.insert(find_command, "--glob")
		table.insert(find_command, "!.DS_Store")

		vim.keymap.set("n", "<leader>pe", function()
			require("telescope.builtin").find_files({
				find_command = find_command,
				prompt_title = "Find .env Files",
			})
		end, { desc = "Find .env* files" })

		vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
		-- vim.keymap.set("n", "<leader>ps", function()
		-- 	builtin.grep_string({ search = vim.fn.input("Grep > ") })
		-- end)
		vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "List open buffers" })
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "List vim help tags" })
		vim.keymap.set("n", "<leader>ls", "<cmd>Telescope live_grep<cr>")
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
		vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
		vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
		vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
		vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
		vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })

		require("user.telescope").setup()
	end,
}
