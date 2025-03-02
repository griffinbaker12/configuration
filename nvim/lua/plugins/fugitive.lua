return {
	"tpope/vim-fugitive",
	dependencies = {
		"szw/vim-maximizer",
	},
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		vim.keymap.set("n", "<leader>gd", function()
			vim.cmd("MaximizerToggle")
			vim.cmd("Gvdiffsplit")
		end)

		vim.keymap.set("n", "<leader>gm", function()
			vim.cmd("MaximizerToggle")
			vim.cmd("Gvdiffsplit!")
		end)

		vim.keymap.set("n", "<leader>gw", function()
			vim.cmd("Gwrite") -- Write the changes
			vim.cmd("only") -- Close all other windows
			vim.cmd("Git") -- Open the fugitive status window
		end)

		local User_Fugitive = vim.api.nvim_create_augroup("UserFigutiveConfig", {})
		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = User_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end
				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "<leader>gp", function()
					vim.cmd.Git("push")
				end, opts)
				vim.keymap.set("n", "<leader>gP", function()
					vim.cmd.Git("pull")
				end, opts)
				-- NOTE: It allows me to easily set the branch i am pushing and any tracking
				-- needed if i did not set the branch up correctly
				vim.keymap.set("n", "<leader>gt", function()
					local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
					vim.cmd("Git push -u origin " .. branch)
				end, opts)
			end,
		})

		-- Diff view navigation
		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

		-- Toggle between diff view and single file view
		vim.keymap.set("n", "<leader>dt", function()
			if vim.o.diff then
				vim.cmd("only")
				vim.cmd("Git")
			else
				vim.cmd("Gvdiffsplit")
			end
		end)
	end,
}
